#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

#Install and sngrep
echo ""
verbose "Installing and configuring sngrep"
yum $AUTO install sngrep --enablerepo=irontec
