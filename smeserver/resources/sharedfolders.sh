#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

#Install SharedFolders
yum $AUTO --enablerepo=smecontribs,epel install smeserver-shared-folders fuse-encfs $DEBUG

#Restart Apache
expand-template /etc/httpd/conf/httpd.conf
service httpd-e-smith restart
