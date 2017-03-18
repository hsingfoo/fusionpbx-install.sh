#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmailcom

clear

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./resources/config.sh
. ./resources/colors.sh

# SME Server 9 64-bit install
verbose "Installation of Freeswitch 1.6, FusionPBX 4.2, PostgreSQL 9.4, memcached, SCL and php-fpm on SME Server 9.1"

# Update SME Server 
echo ""
verbose "Updating SME Server"
yum -y -q update

# Installing repositories
resources/repos.sh

# Installing SME Server specifics
resources/smeserver.sh
# Adjusting IP Tables
resources/iptables.sh

# switch to SCL enabled environment
scl enable php56 'bash install_scl_enabled.sh && exit'
