#!/bin/sh

service freeswitch stop
service postgresql-9.4 stop
service memcached stop
service php-fpm stop
service haveged stop


db domains delete pbx.sipking.com
yum remove smeserver-webapps-common
yum remove scl-util
yum remove smeserver-php-scl php5*
yum remove sngrep
yum remove memcached
yum remove freeswitch
yum remove postgresql
yum remove haveged

rm -Rf/var/lib/pgsql/9.4
rm -Rf /etc/freeswitch
rm -Rf /opt/fusionpbx
rm -Rf /var/lib/freeswitch
rm -Rf /usr/lib/freeswitch
rm -f //etc/rc.d/rc7.d/S98memcached
rm -f //etc/rc.d/rc7.d/S98php-fpm
rm -f //etc/rc.d/rc7.d/S99freeswitch
rm -f //etc/rc.d/rc7.d/S64postgresql-9.4
rm -Rf /usr/src/fusionpbx-install.sh
rm -Rf /usr/src/install.sh

echo "All removed, please perform a 'signal-event post-upgrade; signal-event reboot'
