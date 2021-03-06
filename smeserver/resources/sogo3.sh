#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

# move to script directory so all relative paths work
cd "$(dirname "$0")"

# Includes
. ./config.sh
. ./colors.sh

# Install and configure memcached (Nextcloud script does this too on-purpose!)
./memcached.sh

#send a message
verbose "Installing Sogo3"
yum install $AUTO --enablerepo=stephdl,epel,sogo3,fws smeserver-sogo
config setprop sogod ActiveSync enabled
signal-event sogo-modify; config set UnsavedChanges no
db configuration setprop dovecot AdminIsMaster enabled
signal-event email-update
