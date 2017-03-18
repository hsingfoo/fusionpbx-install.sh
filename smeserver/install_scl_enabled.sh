#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmailcom

clear

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./resources/config.sh
. ./resources/colors.sh

#FreeSWITCH
resources/switch/smeserver-freeswitch.sh

#FusionPBX
resources/fusionpbx.sh

#Postgres
resources/postgres.sh

# FusionPBX to FreeSWITCH configs
#verbose "Configuring freeswitch"
resources/switch/conf-copy.sh
#verbose "freeswitch configured"

#Fail2ban
#resources/fail2ban.sh

#restart services
echo ""
verbose "Restarting packages for final configuration"
service memcached start
service postgresql-9.6 restart
service freeswitch start
service php56-php-fpm start
service httpd-e-smith restart
#fail2ban

#Execute in a new shell with php56 via SCL enabled
resources/finish.sh
resources/permissions.sh
