#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./config.sh
. ./colors.sh

#Install and configure Remi PHP versions
verbose "Installing and configuring php-fpm and SCL php versions"
yum $AUTO install smeserver-webapps-common *pdo_pgsql php*-php-pecl-redis php*-php-pecl-zip php*-php-pecl-apcu php*-php-smbclient --enablerepo=smecontribs,fws,epel,remi-safe
