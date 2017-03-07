#!/bin/sh

#Uninstall all Freeswitch and FusionPBX related files

service freeswitch stop
service postgresql-9.4 stop
service memcached stop
service php-fpm stop
service haveged stop

echo "all services stopped, removing all related files, please wait..."
db domains delete pbx.sipking.com
yum -y remove smeserver-webapps-common > /dev/null 2>&1
yum -y remove scl-util > /dev/null 2>&1
yum -y remove smeserver-php-scl php5* > /dev/null 2>&1
yum -y remove sngrep > /dev/null 2>&1
yum -y remove memcached > /dev/null 2>&1
yum -y remove freeswitch > /dev/null 2>&1
yum -y remove postgresql > /dev/null 2>&1
yum -y remove haveged > /dev/null 2>&1

rm -Rf /var/lib/pgsql/9.4
rm -Rf /etc/freeswitch
rm -Rf /opt/fusionpbx
rm -Rf /var/lib/freeswitch
rm -Rf /usr/lib/freeswitch
rm -f /etc/rc.d/rc7.d/S98memcached
rm -f /etc/rc.d/rc7.d/S98php-fpm
rm -f /etc/rc.d/rc7.d/S99freeswitch
rm -f /etc/rc.d/rc7.d/S64postgresql-9.4
rm -f /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf/fusionpbx
rm -f /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf/20LoadModule60
rm -Rf /usr/src/fusionpbx-install.sh
rm -Rf /usr/src/install.sh
expand-template /etc/httpd/conf/httpd.conf > /dev/null 2>&1
service httpd-e-smith restart > /dev/null 2>&1

echo "All removed, please perform a 'signal-event post-upgrade; signal-event reboot'
