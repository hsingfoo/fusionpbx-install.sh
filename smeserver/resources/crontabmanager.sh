#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./config.sh
. ./colors.sh

verbose "Installing Crontab Manager"
yum $AUTO install smeserver-crontab_manager --enablerepo=smecontribs

