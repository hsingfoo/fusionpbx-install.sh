#!/bin/sh

clear

#Uninstall all Freeswitch and FusionPBX related files
echo "Stopping all related services..."
service freeswitch stop
service postgresql-9.4 stop
service php56-php-fpm stop

echo ""
echo "all services stopped, removing all related files, please wait..."

#Delete ibay and domain
signal-event domain-delete tel.sipking.com
signal-event ibay-delete fusionpbx

#Remove packages
yum -y remove freeswitch
yum -y remove scl-util
yum -y remove smeserver-php-scl php54-* php55-* php56-*
yum -y remove php56-php-fpm
yum -y remove sngrep
yum -y remove memcached
yum -y remove postgresql
yum -y remove haveged
yum -y remove ffmpeg
yum -y remove lame
yum -y remove ghostscript
yum -y remove ilbc2
yum -y remove freeswitch-cli
yum -y remove mod_proxy_wstunnel

#remove directories, files and symlinks
rm -Rf /var/lib/pgsql/9.4
rm -Rf /etc/freeswitch
rm -Rf /etc/freeswitch.orig
rm -Rf /var/lib/freeswitch
rm -Rf /usr/share/freeswitch
rm -Rf /usr/share/lib64/freeswitch
rm -Rf /usr/lib64/freeswitch
rm -Rf /var/run/freeswitch
rm -f /etc/rc.d/rc7.d/S90memcached
rm -f /etc/rc.d/rc7.d/S98php56-php-fpm
rm -f /etc/rc.d/rc7.d/S99freeswitch
rm -f /etc/rc.d/rc7.d/S64postgresql-9.4
rm -f /etc/rc.d/rc7.d/S90haveged
rm -f /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf/fusionpbx
rm -f /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf/20LoadModule60
expand-template /etc/httpd/conf/httpd.conf
service httpd-e-smith restart

#remove users
userdel postgres

echo ""
echo "All removed, please perform a 'signal-event post-upgrade; signal-event reboot'"
