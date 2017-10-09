#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./resources/config.sh
. ./resources/colors.sh

verbose "Copying default configuration"
mv /etc/freeswitch /etc/freeswitch.orig
mkdir /etc/freeswitch
cp -R $www_path/resources/templates/conf/* /etc/freeswitch
