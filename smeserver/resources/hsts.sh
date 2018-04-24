#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

#
echo creating custom template for HSTS
mkdir -p /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf/VirtualHosts/
cat <<HERE1 > /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf/VirtualHosts/04StrictTransportSecurity
### Enable HTTP Strict Transport Security, lifetime 6 months  ###
Header always add Strict-Transport-Security "max-age=15768000; includeSubDomains; preload" env=HTTPS
HERE1
expand-template /etc/httpd/conf/httpd.conf
service httpd-e-smith restart $DEBUG
