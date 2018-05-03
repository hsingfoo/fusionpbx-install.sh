#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#clear

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./resources/config.sh
. ./resources/colors.sh

# SME Server 9.2 64-bit install
# Update SME Server 
verbose "Updating platform"
yum $AUTO update --enablerepo=smeupdates-testing

# Branding
resources/branding.sh

# Installing SME Server specifics
resources/smeserver.sh

# Installing repositories
resources/repos.sh

# Installing PHP-SCL
resources/php-scl.sh

# Shared Folders
resources/sharedfolders.sh

# Install contribs
#resources/contribs.sh

# switch to SCL enabled environment
scl enable php$php_version 'bash install_scl_enabled.sh && exit'

# set FusionPBX permissions
resources/permissions.sh
