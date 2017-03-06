#!/bin/sh

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

#FreeSWITCH
resources/switch/package-release.sh

#FusionPBX
resources/fusionpbx.sh

#Postgres
resources/postgres.sh

#PHP/PHP-FPM
resources/php.sh

# FusionPBX to FreeSWITCH configs
verbose "Configuring freeswitch"
resources/switch/conf-copy.sh
resources/switch/package-permissions.sh
resources/switch/package-systemd.sh
verbose "freeswitch configured"

#Fail2ban
#resources/fail2ban.sh

#restart services
verbose "Restarting packages for final configuration"
service freeswitch start
service php-fpm
service https-e-smith restart
#fail2ban
verbose "Restart of service complete"

#add the database schema, user and groups
resources/finish.sh
