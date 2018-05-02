#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

verbose "Installing webfilter"
yum $AUTO install smeserver-webfilter --enablerepo=fws,epel

# Enable content anti-virus scanning
config setprop squidclamav status enabled
db configuration setprop squidguard RedirectUrl \
http://hostname.systemname.com/squidGuard/cgi-bin/custom.cgi?clientaddr=%a&clientname=%n&clientuser=%i&clientgroup=%s&targetgroup=%t&url=%u
db configuration setprop squidguard BlockedCategories 'adult,agressif,cryptojacking,dating,ddos,dialer,drogue,hacking,malware,phishing,redirector,warez'

# Set custom blockmessage page and set parameters
cp -a /usr/share/squidGuard/cgi-bin/blocked.cgi /usr/share/squidGuard/cgi-bin/custom.
mkdir -p /etc/e-smith/templates-custom/usr/share/squidGuard/conf.txt
cp -a /etc/e-smith/templates/usr/share/squidGuard/conf.txt/10All /etc/e-smith/templates-custom/usr/share/squidGuard/conf.txt

# Set number of retention days for the Squid MySQL log
db configuration setprop squid-db-logd Retention 180

# Finish
verbose "Updating initial filter databases, this can take quite a long time. Please wait..."
signal-event http-proxy-update
expand-template /etc/httpd/conf/httpd.conf
sv t /service/httpd-e-smith
