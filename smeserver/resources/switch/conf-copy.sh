#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ../config.sh
. ../colors.sh

verbose "Copying default FusionPBX configuration"
mv /etc/freeswitch /etc/freeswitch.orig
mkdir /etc/freeswitch
cp -R $fusionpbx_path/resources/templates/conf/* /etc/freeswitch

