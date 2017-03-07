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

rm -Rf /var/log/pgsql/9.4/data
rm -Rf /etc/freeswitch
rm -Rf /opt/fusionpbx
rm -Rf /var/lib/freeswitch
rm -Rf /usr/lib/freeswitch
rm -f /etc/rc.d/rc7.d/*haveged *memcached *freeswitch *php-fpm *postgres*
