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
sed -i 's|# unixsocket.*|unixsocket /var/run/redis/redis.sock|' /etc/redis.conf
sed -i 's|# unixsocketperm.*|unixsocketperm 777|' /etc/redis.conf
mkdir -p /var/run/redis
chown -R redis:redis /var/run/redis/redis.sock
/etc/rc.d/init.d/redis start

# Note: phpxx-php-pecl-redis (for nextcloud) already installed by php-scl procedure
