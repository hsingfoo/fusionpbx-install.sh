#!/bin/sh
clear

# SME Server 9 64-bit install
verbose "Installation of Freeswitch 1.6, FusionPBX 4.2, PostgreSQL 9.4, memcached, SCL and php-fpm on SME Server 9.1"

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./resources/colors.sh

# Update SME Server 
verbose "Updating SME Server"
yum -y -q update > /dev/null 2>&1

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

# FusionPBX to FreeSWITCH configs
#verbose "Configuring freeswitch"
resources/switch/conf-copy.sh
resources/permissions.sh
#verbose "freeswitch configured"

#Fail2ban
#resources/fail2ban.sh

#restart services
echo ""
verbose "Restarting packages for final configuration"
service memcached start > /dev/null 2>&1
service postgresql-9.4 restart > /dev/null 2>&1
service freeswitch start > /dev/null 2>&1
service php-fpm start > /dev/null 2>&1
service httpd-e-smith restart > /dev/null 2>&1
#fail2ban

#Execute in a new shell with php56 via SCL enabled
scl enable php56 'bash resources/finish.sh && exit'
