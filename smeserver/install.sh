#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#clear

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./resources/config.sh
. ./resources/colors.sh

# SME Server 9 64-bit install
verbose "Installation of Freeswitch, FusionPBX, PostgreSQL, memcached, SCL and php-fpm on SME Server 9"

# Update SME Server 
echo ""
verbose "Updating SME Server"
yum $AUTO -q update --enablerepo=smeupdates-testing

# Installing SME Server specifics
resources/smeserver.sh

# Installing contribs
resources/contribs.sh

# switch to SCL enabled environment
scl enable php$php_version 'bash resources/install_scl_enabled.sh && exit'
