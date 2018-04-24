#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

#Install memcached
echo ""
verbose "Installing and configuring memached"
yum $AUTO install memcached $DEBUG
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S90memcached
config set memcached service status enabled
/etc/rc.d/init.d/memcached start $DEBUG
