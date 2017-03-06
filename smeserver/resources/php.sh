#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

. ./colors.sh

echo ""
verbose "Configuring php/php-fpm and permissions"

sed -ie "s|listen = 127.0.0.1:9000|listen = /var/run/php-fpm/php-fpm.sock|g" /etc/php-fpm.d/www.conf
sed -ie 's/;listen.owner = nobody/listen.owner = nobody/g' /etc/php-fpm.d/www.conf
sed -ie 's/;listen.group = nobody/listen.group = nobody/g' /etc/php-fpm.d/www.conf
sed -ie 's/user = apache/user = freeswitch/g' /etc/php-fpm.d/www.conf
sed -ie 's/group = apache/group = daemon/g' /etc/php-fpm.d/www.conf
mkdir -p /var/lib/php/session
chown -R freeswitch:daemon /var/lib/php/session
chmod -Rf 700 /var/lib/php/session

# Set ownership and permission

chown -R freeswitch.daemon /etc/freeswitch /var/lib/freeswitch /var/log/freeswitch /usr/share/freeswitch /opt/fusionpbx
find /etc/freeswitch -type d -exec chmod 770 {} \;
find /var/lib/freeswitch -type d -exec chmod 770 {} \;
find /var/log/freeswitch -type d -exec chmod 770 {} \;
find /usr/share/freeswitch -type d -exec chmod 770 {} \;
find /opt/fusionpbx -type d -exec chmod 770 {} \;
find /etc/freeswitch -type f -exec chmod 664 {} \;
find /var/lib/freeswitch -type f -exec chmod 664 {} \;
find /var/log/freeswitch -type f -exec chmod 664 {} \;
find /usr/share/freeswitch -type f -exec chmod 664 {} \;
find /opt/fusionpbx -type f -exec chmod 664 {} \;

echo ""
verbose "php/php-fpm and permissions configured"