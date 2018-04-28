#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#clear

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./resources/config.sh
. ./resources/colors.sh

# SME Server 9.2 64-bit install
verbose "Installation of Freeswitch, FusionPBX, PostgreSQL, memcached, SCL and php-fpm on SME Server 9.2"

# Update SME Server 
echo ""
verbose "Updating SME Server"
yum $AUTO update --enablerepo=smeupdates-testing

# Branding
resources/branding.sh

# Installing SME Server specifics
resources/smeserver.sh

# Installing repositories
resources/repos.sh

# Installing PHP-SCL
resources/php-scl.sh

# Adjusting IP Tables
resources/iptables.sh

# Install contribs
resources/contribs.sh

# switch to SCL enabled environment
scl enable php$php_version 'bash install_scl_enabled.sh && exit'
