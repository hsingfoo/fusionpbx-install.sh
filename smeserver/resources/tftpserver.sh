#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./config.sh
. ./colors.sh

verbose "Installing TFTP server"
yum $AUTO --enablerepo=smecontribs install smeserver-tftp-server $DEBUG
config setprop tftpd status enabled
signal-event tftpd-conf
service tftpd restart
