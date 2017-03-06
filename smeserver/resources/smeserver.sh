#!/bin/bash

verbose "Installation of Freeswitch 1.6, FusionPBX 4.2, PostgreSQL 9.4, memcached, SCL php and php-fpm on SME Server 9.1"

#Install and configure Remi PHP versions
verbose "Installing SCL php versions"
yum -y install smeserver-php-scl php5*-php-pdo_pgsql --enablerepo=smecontribs,remi,epel
config setprop php56 PhpModule enabled UploadMaxFilesize 80M PostMaxSize 80M
signal-event php-update; config set UnsavedChanges no

#Install memcached and php-fpm
verbose "Installing memached and php-fpm"
yum -y install memcached php-fpm
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S98memcached
config set memcached service
/etc/rc.d/init.d/memcached start

ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S98php-fpm
config set php-fpm service status enabled
sed -ie "s|listen = 127.0.0.1:9000|listen = /var/run/php-fpm/php-fpm.sock|g" /etc/php-fpm.d/www.conf
sed -ie 's/;listen.owner = nobody/listen.owner = nobody/g' /etc/php-fpm.d/www.conf
sed -ie 's/;listen.group = nobody/listen.group = nobody/g' /etc/php-fpm.d/www.conf
sed -ie 's/user = apache/user = freeswitch/g' /etc/php-fpm.d/www.conf
sed -ie 's/group = apache/group = daemon/g' /etc/php-fpm.d/www.conf
mkdir -p /var/lib/php/session
chown -R freeswitch:daemon /var/lib/php/session
chmod -Rf 700 /var/lib/php/session
/etc/rc.d/init.d/php-fpm start

#Install haveged"
verbose "Installing haveged"
yum -y install haveged --enablerepo=epel
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S98haveged
config set haveged service
/etc/rc.d/init.d/haveged start

#Install and configure Apche proxy ws_tunnel
verbose "Installing mod proxy wstunnel"
yum -y install mod_proxy_wstunnel* --enablerepo=fws
mkdir -p /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf
cat <<HERE1 > /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf/20LoadModule60
{
   load_modules(qw(
   proxy_wstunnel
   ));
}
HERE1

expand-template /etc/httpd/conf/httpd.conf
service httpd-e-smith restart

verbose "Pre-configuration for SME Server done"
echo ""
