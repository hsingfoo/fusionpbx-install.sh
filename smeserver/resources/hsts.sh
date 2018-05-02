#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

verbose "creating custom template for HSTS"
# Template for normal virtual servers
mkdir -p /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf/VirtualHosts/
cat <<HERE1 > /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf/VirtualHosts/04StrictTransportSecurity
	### Enable HTTP Strict Transport Security, lifetime 6 months  ###
	Header always add Strict-Transport-Security "max-age=15768000; includeSubDomains; preload" env=HTTPS
HERE1
expand-template /etc/httpd/conf/httpd.conf
service httpd-e-smith restart

# Template for webapps virtual hosts
mkdir -p /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf/WebAppVirtualHost
cat <<HERE2	> /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf/WebAppVirtualHost/04StrictTransportSecurity
	### Enable HTTP Strict Transport Security, lifetime 6 months  ###
	Header always add Strict-Transport-Security "max-age=15768000; includeSubDomains; preload" env=HTTPS
HERE2
signal-event webapps-update
service php71-php-fpm restart
