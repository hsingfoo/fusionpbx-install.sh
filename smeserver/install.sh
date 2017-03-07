#!/bin/sh
clear
# SME Server 9 64-bit install

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./resources/colors.sh

# Update SME Server 
verbose "Updating SME Server"
yum -y update

# Installing repositories
resources/repos.sh

# Installing SME Server specifics
resources/smeserver.sh

#Installing SME Server Sub-domain
resources/smeserver-subdomain.sh

#FreeSWITCH
resources/switch/smeserver-freeswitch.sh

#FusionPBX
resources/fusionpbx.sh

#Postgres
resources/postgres.sh

echo ""
verbose "Copying config files and set system wide ownership and permissions"
# FusionPBX to FreeSWITCH configs
#verbose "Configuring freeswitch"
resources/switch/conf-copy.sh
resources/permissions.sh
#verbose "freeswitch configured"

#Fail2ban
#resources/fail2ban.sh

#restart services
verbose "Restarting packages for final configuration"
service memcached restart
service postgresql-9.4 restart
service freeswitch restart
service php-fpm start
service httpd-e-smith restart
#fail2ban
verbose "Restart of service complete"

#Switch to PHP56 from Software collections for this final part
scl enable php56 'bash'

#add the database schema, user and groups
resources/finish.sh

#Switch back out of SCL to the original shell
exit
