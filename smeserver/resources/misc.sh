#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

#
echo Installing user-panel and user-panels, vacation, remoteuseraccess, wordpress, dehydrated and check4updates
yum $AUTO install smeserver-userpanel smeserver-userpanels smeserver-vacation smeserver-remoteuseraccess smeserver-wordpress dehydrated smeserver-check4updates --enablerepo=smecontribs,fws,epel
signal-event wordpress-update
