#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

#Install and Affa
verbose "Installing and configuring Affa"
yum $AUTO install smeserver-affa --enablerepo=smecontribs
