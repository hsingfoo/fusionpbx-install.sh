#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#clear

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./resources/config.sh
. ./resources/colors.sh

#FusionPBX
resources/fusionpbx.sh

#Postgres
resources/postgres.sh

# FusionPBX to FreeSWITCH configs
resources/switch/conf-copy.sh

#restart services
echo ""
verbose "Restarting packages for final configuration"
service memcached start
service postgresql-$database_version restart
service freeswitch start
service php$php_version-php-fpm start
service httpd-e-smith restart

resources/finish.sh
resources/permissions.sh
