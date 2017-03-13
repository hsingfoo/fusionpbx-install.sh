#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

. ./colors.sh
# Set ownership and permission

mkdir -p /var/lib/php/session
chown -R freeswitch:daemon /var/lib/php/session
chmod -Rf 700 /var/lib/php/session

#update config if source is being used
#sed -ie 's/post_max_size = .*/post_max_size = 80M/g' /etc/php.ini
#sed -ie 's/upload_max_filesize = .*/upload_max_filesize = 80M/g' /etc/php.ini

chown -R freeswitch:daemon /etc/freeswitch
chown -R freeswitch:daemon /var/lib/freeswitch
chown -R freeswitch:daemon /usr/share/freeswitch
chown -R freeswitch:daemon /var/log/freeswitch
chown -R freeswitch:daemon /var/run/freeswitch

find /etc/freeswitch -type d -exec chmod 770 {} \;
find /var/lib/freeswitch -type d -exec chmod 770 {} \;
find /var/log/freeswitch -type d -exec chmod 770 {} \;
find /usr/share/freeswitch -type d -exec chmod 770 {} \;
find $www_path -type d -exec chmod 770 {} \;
find /etc/freeswitch -type f -exec chmod 664 {} \;
find /var/lib/freeswitch -type f -exec chmod 664 {} \;
find /var/log/freeswitch -type f -exec chmod 664 {} \;
find /usr/share/freeswitch -type f -exec chmod 664 {} \;
find $wwww_path -type f -exec chmod 664 {} \;
