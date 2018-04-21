#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

#Install and configure Remi PHP versions
echo ""
verbose "Installing and configuring php-fpm and SCL php versions"
yum -y install smeserver-webapps-common *pdo_pgsql --enablerepo=smecontribs,fws,epel,remi-safe
verbose "Relaxing to allow Yum to settle down..."
sleep 4
#Install memcached
echo ""
verbose "Installing and configuring memached"
yum -y install memcached
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S90memcached
config set memcached service status enabled

#Install haveged"
echo ""
verbose "Installing and configuring haveged"
yum -y install haveged --enablerepo=epel
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S90haveged
config set haveged service status enabled

#Install git and sngrep
echo ""
verbose "Installing and configuring sngrep"
yum -y install sngrep --enablerepo=irontec

#Install SharedFolders
yum -y --enablerepo=smecontribs install smeserver-shared-folders
yum -y --enablerepo=smecontribs --enablerepo=epel install fuse-encfs

#Restart Apache
expand-template /etc/httpd/conf/httpd.conf
service httpd-e-smith restart
