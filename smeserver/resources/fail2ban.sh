#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./config.sh
. ./colors.sh

#
verbose "Installing fail2ban"
yum $AUTO --enablerepo=fws --enablerepo=epel install smeserver-fail2ban
db configuration setprop masq status enabled
expand-template /etc/rc.d/init.d/masq
/etc/init.d/masq restart
signal-event fail2ban-conf
# Manually create check_ban script from wiki page

#move the filters
cp ./fail2ban/freeswitch-dos.conf /etc/fail2ban/filter.d/freeswitch-dos.conf
cp ./fail2ban/freeswitch-ip.conf /etc/fail2ban/filter.d/freeswitch-ip.conf
cp ./fail2ban/freeswitch-404.conf /etc/fail2ban/filter.d/freeswitch-404.conf
cp ./fail2ban/freeswitch.conf /etc/fail2ban/filter.d/freeswitch.conf
cp ./fail2ban/fusionpbx.conf /etc/fail2ban/filter.d/fusionpbx.conf
cp ./fail2ban/jail.local /etc/fail2ban/jail.local

service fail2ban restart

