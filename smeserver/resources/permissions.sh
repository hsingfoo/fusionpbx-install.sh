#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

. ./colors.sh
# Set ownership and permission

chown -R www:www /etc/freeswitch /var/lib/freeswitch /var/log/freeswitch /usr/share/freeswitch
find /etc/freeswitch -type d -exec chmod 775 {} \;
find /var/lib/freeswitch -type d -exec chmod 770 {} \;
find /var/log/freeswitch -type d -exec chmod 775 {} \;
find /usr/share/freeswitch -type d -exec chmod 775 {} \;
find /etc/freeswitch -type f -exec chmod 664 {} \;
find /var/lib/freeswitch -type f -exec chmod 664 {} \;
find /var/log/freeswitch -type f -exec chmod 664 {} \;
find /usr/share/freeswitch -type f -exec chmod 775 {} \;
