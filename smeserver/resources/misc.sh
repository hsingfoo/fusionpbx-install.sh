#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

#
verbose "Installing user-panel and user-panels, vacation, remoteuseraccess, wordpress, dehydrated and check4updates"
yum $AUTO install smeserver-userpanel smeserver-userpanels smeserver-vacation smeserver-remoteuseraccess smeserver-wordpress smeserver-check4updates --enablerepo=smecontribs,fws,epel
signal-event wordpress-update
signal-event conf-userpanel
