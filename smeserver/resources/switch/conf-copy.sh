#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

verbose "Copying default FusionPBX configuration"
mv /etc/freeswitch /etc/freeswitch.orig
mkdir /etc/freeswitch
cp -R $www_path/resources/templates/conf/* /etc/freeswitch
