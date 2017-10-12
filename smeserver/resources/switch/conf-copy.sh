#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#Includes
. ./colors.sh
. ./config.sh

verbose "Copying default FusionPBX configuration"
mv /etc/freeswitch /etc/freeswitch.orig
mkdir /etc/freeswitch
cp -R $www_path/resources/templates/conf/* /etc/freeswitch
