#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./config.sh
. ./colors.sh

# Lemon-ldap-ng
verbose "Installing Lemon-LDAP-ng"
yum $AUTO install smeserver-lemonldap-ng --enablerepo=fws,epel
signal-event webapps-update
db configuration set UnsavedChanges no
