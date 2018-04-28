#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

#
verbose "Installing Redis"
yum $AUTO --enablerepo=epel install redis
config set redis service status enabled
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S80redis
usermod -a -G redis www

# Replace default values is /etc/rdeis.conf
sed -i "s|# unixsocket /tmp/redis.sock|unixsocket /var/run/redis/redis.sock|" /etc/redis.conf
sed -i 's|# unixsocketperm 700|unixsocketperm 777|' /etc/redis.conf

# Create /var/run/redis and set permissions
mkdir -p /var/run/redis
chown -R redis:redis /var/run/redis
/etc/rc.d/init.d/redis start
