#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./colors.sh

#Install and configure FusionPBX
echo ""
verbose "Installing and configuring FusionPBX 4.2.x"
yum -y -q install git > /dev/null 2>&1
yum -y -q install sngrep --enablerepo=irontec > /dev/null 2>&1
git clone -b 4.2 https://github.com/fusionpbx/fusionpbx.git /opt/fusionpbx > /dev/null 2>&1

# Adjust some Debian assumptions to Generic/CentOS
sed -i 's/= "localhost"/= "127.0.0.1"/g' /opt/fusionpbx/core/install/resources/classes/install_fusionpbx.php
chown -R www:www /opt/fusionpbx
echo ""
verbose "FusionPBX installed"
