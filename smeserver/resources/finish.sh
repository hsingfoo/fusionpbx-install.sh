#!/bin/sh

#Note: ** Please be aware that this part of the script is executed in a new shell where php56 is active. see install.sh **

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./colors.sh

#database details
database_host=127.0.0.1
database_port=5432
database_username=fusionpbx
database_password=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64 | sed 's/[=\+//]//g')
#database_password=supersecret

#Set some paths again for this script is running SCL in a new shell, so previous exported values are not available
export www_path=/home/e-smith/files/ibays/fusionpbx/html
export sub_domain=tel

#allow the script to use the new password
export PGPASSWORD=$database_password

#update the database password
sudo -u postgres psql -c "ALTER USER fusionpbx WITH PASSWORD '$database_password';"
sudo -u postgres psql -c "ALTER USER freeswitch WITH PASSWORD '$database_password';"

#add the config.php
cp /usr/src/fusionpbx-install.sh/smeserver/resources/fusionpbx/config.php $www_path/resources
sed -i $www_path/resources/config.php -e s:'{database_username}:fusionpbx:'
sed -i $www_path/resources/config.php -e s:"{database_password}:$database_password:"

# SME Server specific storage of PostgreSQL details
config setprop postgreslq-9.4 FusionpbxDBname fusionpbx FusionpbxDBuser fusionpbx FusionDBpass $database_password FreeswitchDBname fusionpbx FreeswitchDBuser fusionpbx FreeswitchDBpass $database_password
 
#add the database schema
php -v
cd $www_path && php core/upgrade/upgrade_schema.php > /dev/null 2>&1

#get the server FQDN which is used for the default FusionPBX domain and initial admin login
domain_name=$sub_domain.$(hostname -d)

#get the ip address
#domain_name=$(hostname -I | cut -d ' ' -f1)

#get a domain_uuid
domain_uuid=$(php $www_path/resources/uuid.php);

#add the domain name
#sudo -u postgres psql --host=$database_host --port=$database_port --username=$database_username -c "insert into v_domains (domain_uuid, domain_name, domain_enabled) values('$domain_uuid', '$domain_name', 'true');"
sudo -u postgres psql -c "insert into v_domains (domain_uuid, domain_name, domain_enabled) values('$domain_uuid', '$domain_name', 'true');"


#app defaults
cd $www_path && php $www_path/core/upgrade/upgrade_domains.php

#add the user
user_uuid=$(php $www_path/resources/uuid.php);
user_salt=$(php $www_path/resources/uuid.php);
user_name=admin
user_password=$(dd if=/dev/urandom bs=1 count=12 2>/dev/null | base64 | sed 's/[=\+//]//g');
password_hash=$(php -r "echo md5('$user_salt$user_password');");
#sudo -u postgres psql --host=$database_host --port=$database_port --username=$database_username -t -c "insert into v_users (user_uuid, domain_uuid, username, password, salt, user_enabled) values('$user_uuid', '$domain_uuid', '$user_name', '$password_hash', '$user_salt', 'true');"
sudo -u postgres psql -c "insert into v_users (user_uuid, domain_uuid, username, password, salt, user_enabled) values('$user_uuid', '$domain_uuid', '$user_name', '$password_hash', '$user_salt', 'true');"

#get the superadmin group_uuid
group_uuid=$(sudo -u postgres psql --host=$database_host --port=$database_port --username=$database_username -t -c "select group_uuid from v_groups where group_name = 'superadmin';");
group_uuid=$(echo $group_uuid | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//')

#add the user to the group
group_user_uuid=$(php $www_path/resources/uuid.php);
group_name=superadmin
#sudo -u postgres psql --host=$database_host --port=$database_port --username=$database_username -c "insert into v_group_users (group_user_uuid, domain_uuid, group_name, group_uuid, user_uuid) values('$group_user_uuid', '$domain_uuid', '$group_name', '$group_uuid', '$user_uuid');"
sudo -u postgres psql -c "insert into v_group_users (group_user_uuid, domain_uuid, group_name, group_uuid, user_uuid) values('$group_user_uuid', '$domain_uuid', '$group_name', '$group_uuid', '$user_uuid');"

# Setting back postgresql authentication to md5
#sed -i 's/\(host  *all  *all  *127.0.0.1\/32  *\)ident/\1md5/' /var/lib/pgsql/9.4/data/pg_hba.conf


#update xml_cdr url, user and password
xml_cdr_username=$(dd if=/dev/urandom bs=1 count=12 2>/dev/null | base64 | sed 's/[=\+//]//g')
xml_cdr_password=$(dd if=/dev/urandom bs=1 count=12 2>/dev/null | base64 | sed 's/[=\+//]//g')
sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_http_protocol}:http:"
sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{domain_name}:127.0.0.1:"
sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_project_path}::"
sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_user}:$xml_cdr_username:"
sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_pass}:$xml_cdr_password:"

#Store xml_cdr_conf username and password in the Freeswitch db key
config setprop freeswitch XML_CDR_User $xml_cdr_username XML_CDR_Password $xml_cdr_password

#app defaults
cd $www_path && php $www_path/core/upgrade/upgrade_domains.php

# Setting fusionpbx SME Server db keys
config set fusionpbx configuration DomainName $domain_name DBName fusionpbx DBUser $user_name DBPassword $user_password XMLCDRUser $xml_cdr_username XMLCDRPassword $xml_cdr_password

#welcome message
echo ""
echo ""
verbose "Installation has completed."
echo ""
error "Please note details below and reboot your system"
error "           'config show fusionpbx'             "
error "                    and                        "
error "        'config show prostgresql-9.4'          "
error "                    and                        "
error "           'config show freeswitch             "
error "            will show the details              "
echo ""
echo "   Use a web browser to login."
echo "      domain name: https://$domain_name"
echo "      username: $user_name"
echo "      password: $user_password"
echo ""
echo "   The domain name in the browser is used by default as part of the authentication."
echo "   If you need to login to a different domain then use username@domain."
echo "      username: $user_name@$domain_name";
echo ""
echo "   Additional information."
echo "      https://contribs.org"
echo "      https://fusionpbx.com/support.php"
echo "      https://www.fusionpbx.com"
echo "      http://docs.fusionpbx.com"
warning "*----------------------------------------------- *"
warning "*    NOTE: Please save the above information.    *"
warning "* REBOOT YOUR SME SERVER TO COMPLETE THE INSTALL *"
warning "*    											  *"
warning "* signal-event post-upgrade; signal-event reboot *"
warning "*------------------------------------------------*"
echo ""
