#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./config.sh
. ./colors.sh

verbose "Installing PHP software Collections"
#Install and configure Remi PHP versions
echo ""
verbose "Installing and configuring php-fpm and SCL php versions"
yum $AUTO install smeserver-webapps-common *pdo_pgsql php*-php-pecl-redis php*-php-pecl-zip --enablerepo=smecontribs,fws,epel,remi-safe $DEBUG
