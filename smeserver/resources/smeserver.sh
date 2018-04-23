#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

# Set system services and settings
echo Changing some system settings
service smolt stop
config setprop smolt status disabled
service smb stop
config setprop smb status disabled
config setprop sshd AutoBlock disabled
signal-event remoteaccess-update

