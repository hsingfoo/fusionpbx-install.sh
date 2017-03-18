#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmailcom

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

#Install and configure Remi PHP versions
echo ""
verbose "Installing and configuring SCL php versions"
yum -y -q install smeserver-php-scl php5*-php-pdo_pgsql --enablerepo=smecontribs,remi,epel
yum -y -q install php56-php-fpm --enablerepo=remi
config setprop php56 PhpModule enabled UploadMaxFilesize 120M PostMaxSize 120M
signal-event php-update; config set UnsavedChanges no

#Install memcached
echo ""
verbose "Installing and configuring memached"
yum -y -q install memcached
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S90memcached
config set memcached service status enabled

#Install php56-php-fpm (from remi repo for SCL environment)
echo ""
verbose "Installing and configuring php56-php-fpm"
yum -y -q install php56-php-fpm --enablerepo=remi
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S98php56-php-fpm
config set php56-php-fpm service TCPPort 9000 status enabled
sed -ie "s|listen = 127.0.0.1:9000|listen = /opt/remi/php56/root/var/run/php-fpm/php-fpm.sock|g" /opt/remi/php56/root/etc/php-fpm.d/www.conf
sed -ie 's/;listen.owner = nobody/listen.owner = nobody/g' /opt/remi/php56/root/etc/php-fpm.d/www.conf
sed -ie 's/;listen.group = nobody/listen.group = nobody/g' /opt/remi/php56/root/etc/php-fpm.d/www.conf
sed -ie 's/user = apache/user = freeswitch/g' /opt/remi/php56/root/etc/php-fpm.d/www.conf
sed -ie 's/group = apache/group = daemon/g' /opt/remi/php56/root/etc/php-fpm.d/www.conf

#Install haveged"
echo ""
verbose "Installing and configuring haveged"
yum -y -q install haveged --enablerepo=epel
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S90haveged
config set haveged service status enabled

#Install git and sngrep
echo ""
verbose "Installing and configuring sngrep"
yum -y -q install sngrep --enablerepo=irontec

#Install and configure Apache proxy ws_tunnel
echo ""
verbose "Installing and configuring mod proxy wstunnel"
yum -y -q install mod_proxy_wstunnel* --enablerepo=fws
mkdir -p /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf
cat <<HERE1 > /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf/20LoadModule60
{
   load_modules(qw(
   proxy_wstunnel
   ));
}
HERE1

#Restart Apache
expand-template /etc/httpd/conf/httpd.conf
service httpd-e-smith restart
