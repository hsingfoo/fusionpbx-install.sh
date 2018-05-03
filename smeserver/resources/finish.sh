#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#Note: ** Please be aware that this part of the script is executed in a new shell where SCL php is active. **

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

#allow the script to use the new password
export PGPASSWORD=$database_password

#update the database password
sudo -u postgres psql -c "ALTER USER fusionpbx WITH PASSWORD '$database_password';"
sudo -u postgres psql -c "ALTER USER freeswitch WITH PASSWORD '$database_password';"

#add the config.php
cp /usr/src/fusionpbx-install.sh/smeserver/resources/fusionpbx/config.php $fusionpbx_path/resources
sed -i $fusionpbx_path/resources/config.php -e s:'{database_username}:fusionpbx:'
sed -i $fusionpbx_path/resources/config.php -e s:"{database_password}:$database_password:"

# SME Server specific storage of PostgreSQL details
config setprop postgresql-$database_version FusionpbxDBname fusionpbx FusionpbxDBuser fusionpbx FusionDBpass $database_password FreeswitchDBname freeswitch FreeswitchDBuser freeswitch FreeswitchDBpass $database_password

#add the database schema
verbose "Populating FusionPBX database"
cd $fusionpbx_path && php core/upgrade/upgrade_schema.php > /dev/null 2>&1

#get the server FQDN which is used for the default FusionPBX domain and initial admin login
domain_name=$fusionpbx_subdomain.$domain_name

#get a domain_uuid
domain_uuid=$(php $fusionpbx_path/resources/uuid.php);

#add the domain name
verbose "Setting FsionPBX domain name"
cwd=$(pwd)
cd /tmp
sudo -u postgres psql --host=$database_host --port=$database_port --username=$database_username -c "insert into v_domains (domain_uuid, domain_name, domain_enabled) values('$domain_uuid', '$domain_name', 'true');"


#app defaults
cd $fusionpbx_path && php $fusionpbx_path/core/upgrade/upgrade_domains.php

#add the user
verbose "Adding FusionPBX admin user"
user_uuid=$(php $fusionpbx_path/resources/uuid.php);
user_salt=$(php $fusionpbx_path/resources/uuid.php);
user_name=admin
user_password=$(dd if=/dev/urandom bs=1 count=12 2>/dev/null | base64 | sed 's/[=\+//]//g');
password_hash=$(php -r "echo md5('$user_salt$user_password');");
sudo -u postgres psql --host=$database_host --port=$database_port --username=$database_username -t -c "insert into v_users (user_uuid, domain_uuid, username, password, salt, user_enabled) values('$user_uuid', '$domain_uuid', '$user_name', '$password_hash', '$user_salt', 'true');"

#get the superadmin group_uuid
group_uuid=$(sudo -u postgres psql --host=$database_host --port=$database_port --username=$database_username -t -c "select group_uuid from v_groups where group_name = 'superadmin';");
group_uuid=$(echo $group_uuid | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//')

#add the user to the group
group_user_uuid=$(php $fusionpbx_path/resources/uuid.php);
group_name=superadmin
sudo -u postgres psql --host=$database_host --port=$database_port --username=$database_username -c "insert into v_group_users (group_user_uuid, domain_uuid, group_name, group_uuid, user_uuid) values('$group_user_uuid', '$domain_uuid', '$group_name', '$group_uuid', '$user_uuid');"

# Setting back postgresql authentication from trust to md5
sed -i 's/\(host  *all  *all  *127.0.0.1\/32  *\)trust/\1md5/' /var/lib/pgsql/$database_version/data/pg_hba.conf
sed -i 's/\(host  *all  *all  *::1\/128  *\)trust/\1md5/' /var/lib/pgsql/$database_version/data/pg_hba.conf

#update xml_cdr url, user and password
xml_cdr_username=$(dd if=/dev/urandom bs=1 count=12 2>/dev/null | base64 | sed 's/[=\+//]//g')
xml_cdr_password=$(dd if=/dev/urandom bs=1 count=12 2>/dev/null | base64 | sed 's/[=\+//]//g')
sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_http_protocol}:https:"
sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{domain_name}:$domain_name:"
sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_project_path}::"
sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_user}:$xml_cdr_username:"
sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_pass}:$xml_cdr_password:"

#app defaults
cd $fusionpbx_path && php $fusionpbx_path/core/upgrade/upgrade_domains.php

# Setting fusionpbx SME Server db keys
config set fusionpbx configuration DomainName $domain_name \
DBName fusionpbx DBUser $user_name DBPassword $user_password \
XMLCDRUser $xml_cdr_username XMLCDRPassword $xml_cdr_password

# Restart freeswitch with new settings
service freeswitch restart

# Clearing YUM cache
yum -q clean all --enablerepo=*
cd /

#welcome message
echo ""
echo ""
verbose "			Installation has completed."
echo ""
echo "			To see details see:"
echo "			config show fusionpbx"
echo "			config show postgresql-$database_version"
echo "			config show freeswitch"
echo ""
verbose "     	Use a web browser to login to your PBX at:"
verbose "     	domain name: https://$domain_name"
verbose "     	username: $user_name"
verbose "     	password: $user_password"
echo ""
verbose "*----------------------------------------------- *"
verbose "*    NOTE: Please save the above information.    *"
verbose "* REBOOT YOUR SME SERVER TO COMPLETE THE INSTALL *"
verbose "*    											  *"
verbose "* signal-event post-upgrade; signal-event reboot *"
verbose "*------------------------------------------------*"
echo ""
