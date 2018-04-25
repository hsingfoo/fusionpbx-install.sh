#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

#
verbose "Installing Dokuwiki"
yum $AUTO install --enablerepo=fws smeserver-dokuwiki dokuwiki-plugins $DEBUG
signal-event webapps-update
