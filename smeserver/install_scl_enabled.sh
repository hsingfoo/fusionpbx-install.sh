#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#clear

#move to script directory so all relative paths work
cd "$(dirname "$0")"

# Includes
. ./resources/config.sh
. ./resources/colors.sh

# Nextcloud
resources/nextcloud.sh
resources/nextcloud_init.sh
resources/nextcloud_apps.sh
# Set strict permissions on config files
chmod 0640 $cloud_path/config/*
chown -R www:www $cloud_path/*

# sngrep
resources/sngrep.sh

# Freeswitch
resources/smeserver-freeswitch.sh

# FusionPBX
resources/fusionpbx.sh

# FusionPBX to FreeSWITCH configs
resources/switch/conf-copy.sh
resources/permissions.sh

# restart services
verbose "Restarting packages for final configuration"
service memcached restart
service postgresql-$database_version restart
service freeswitch start
service php$php_version-php-fpm start
service httpd-e-smith restart

# Warpping up!
resources/finish.sh

# Setting permissions
resources/permissions.sh

