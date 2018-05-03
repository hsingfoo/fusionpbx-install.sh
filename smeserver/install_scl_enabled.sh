#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#clear

#move to script directory so all relative paths work
cd "$(dirname "$0")"

# Includes
. ./resources/config.sh
. ./resources/colors.sh

# HTTP HSTS
resources/hsts.sh

# memcached
resources/memcached.sh

# Redis
resources/redis.sh

# Nextcloud
resources/nextcloud.sh

# FusionPBX
#resources/fusionpbx.sh

# FusionPBX to FreeSWITCH configs
#resources/switch/conf-copy.sh

# restart services
verbose "Restarting packages for final configuration"
service memcached start
service postgresql-$database_version restart
service freeswitch start
service php$php_version-php-fpm start
service httpd-e-smith restart

# Warpping up!
resources/finish.sh

