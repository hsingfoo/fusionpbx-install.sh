#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

verbose "Installing PHPList"
yum install $AUTO --enablerepo=fws smeserver-phplist $DEBUG
signal-event webapps-update
