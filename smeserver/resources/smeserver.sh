#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

# Set system services and settings
echo Changing some system settings

# Stop and disable Smolt
service smolt stop
config setprop smolt status disabled

# Stop and disable Samba
service smb stop
config setprop smb status disabled

# Disable AutoBlock
config setprop sshd AutoBlock disabled
signal-event remoteaccess-update

# Stop and disable pop3
service pop3 stop
config setprop pop3 status disabled
signal-event email-update

# Enable InnodeDB
db configuration setprop mysqld InnoDB enabled
expand-template /etc/my.cnf
sv t /service/mysqld



