#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

#Install Limesurvey
verbose "Installing and configuring Limesurvey"
yum $AUTO install smeserver-limesurvey --enablerepo=fws,epel
signal-event webapps-update

