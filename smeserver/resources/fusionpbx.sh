#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./colors.sh

#Install and configure FusionPBX

verbose Installing FusionPBX 4.2.x
yum -y install git
yum -y install sngrep --enablerepo=irontec
git clone -b 4.2 https://github.com/fusionpbx/fusionpbx.git /opt/fusionpbx

# Adjust some Debian assumptions to Generic/CentOS
sed -i 's/= "localhost"/= "127.0.0.1"/g' /opt/fusionpbx/core/install/resources/classes/install_fusionpbx.php
chown -R www:www /opt/fusionpbx
echo "FusionPBX installed"
