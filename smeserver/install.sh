#!/bin/sh
clear

#move to script directory so all relative paths work.
cd "$(dirname "$0")"

#Includes
. ./resources/colors.sh

# SME Server 9 64-bit install
verbose "Installation of Freeswitch, FusionPBX, PostgreSQL, memcached, SCL and php-fpm on SME Server 9"

# Update SME Server 
echo ""
verbose "Updating SME Server"
yum -y -q update --enablerepo=smeupdates-testing

# Installing repositories
resources/repos.sh

# Installing SME Server specifics
resources/smeserver.sh

# switch to SCL enabled environment
scl enable php$php_version 'bash resources/install_scl_enabled.sh && exit'
