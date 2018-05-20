#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

# Installing Let's Encrypt/Dehydrated and set default key property to staging and not prod
yum $AUTO install smeserver-letsencrypt-client
config setprop letsencrypt Uri staging
letsencrypt-update
