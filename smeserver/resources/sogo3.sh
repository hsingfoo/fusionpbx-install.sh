#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./config.sh
. ./colors.sh

#send a message
verbose "Installing Sogo3"
yum install $AUTO libmemcached $DEBUG
yum install $AUTO --enablerepo=stephdl,epel,sogo3,fws smeserver-sogo $DEBUG
config setprop sogod ActiveSync enabled
signal-event sogo-modify; config set UnsavedChanges no
db configuration setprop dovecot AdminIsMaster enabled
signal-event email-update
/etc/rc.d/init.d/sogod start
