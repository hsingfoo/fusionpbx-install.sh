#!/bin/bash
#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./colors.sh

verbose "Installation of Freeswitch 1.6, FusionPBX 4.2, PostgreSQL 9.4, memcached, SCL and php-fpm on SME Server 9.1"

#Install and configure Remi PHP versions
echo ""
verbose "Installing and configuring SCL php versions"
yum -y -q install smeserver-php-scl php5*-php-pdo_pgsql --enablerepo=smecontribs,remi,epel > /dev/null 2>&1
config setprop php56 PhpModule enabled UploadMaxFilesize 80M PostMaxSize 80M
signal-event php-update; config set UnsavedChanges no

#Install memcached and php-fpm
echo ""
verbose "Installing and configuring memached"
yum -y -q install memcached php-fpm > /dev/null 2>&1
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S98memcached
config set memcached service

verbose "Installing and configuring php fpm"
echo ""
verbose "Installing php-fpm"
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S98php-fpm
config set php-fpm service status enabled
sed -ie "s|listen = 127.0.0.1:9000|listen = /var/run/php-fpm/php-fpm.sock|g" /etc/php-fpm.d/www.conf
sed -ie 's/;listen.owner = nobody/listen.owner = nobody/g' /etc/php-fpm.d/www.conf
sed -ie 's/;listen.group = nobody/listen.group = nobody/g' /etc/php-fpm.d/www.conf
sed -ie 's/user = apache/user = freeswitch/g' /etc/php-fpm.d/www.conf
sed -ie 's/group = apache/group = daemon/g' /etc/php-fpm.d/www.conf
mkdir -p /var/lib/php/session
#user freeswitch does not exist yet.
chown -R freeswitch:daemon /var/lib/php/session
chmod -Rf 700 /var/lib/php/session

#Install haveged"
echo ""
verbose "Installing and configuring haveged"
yum -y -q install haveged --enablerepo=epel > /dev/null 2>&1
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S98haveged
config set haveged service

#Install and configure Apache proxy ws_tunnel
echo ""
verbose "Installing and configuring mod proxy wstunnel"
yum -y -q install mod_proxy_wstunnel* --enablerepo=fws > /dev/null 2>&1
mkdir -p /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf
cat <<HERE1 > /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf/20LoadModule60
{
   load_modules(qw(
   proxy_wstunnel
   ));
}
HERE1

expand-template /etc/httpd/conf/httpd.conf
service httpd-e-smith restart > /dev/null 2>&1

echo ""
verbose "Pre-configuration for SME Server done"
echo ""
