#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./colors.sh

#Configure the new 'fusionpbx' ibay
next_id=$(config get MinUid)
let "new_next_id = next_id + 1"
db configuration set MinUid $new_next_id

#Populate the accounts db with the new ibay details
db accounts set fusionpbx ibay Name fusionpbx \
Group admin UserAccess wr-group-rd-everyone \
Uid $next_id Gid $next_id CgiBin enabled PasswordSet no \
SSL enabled PublicAccess global \

#Create the fusionpbx ibay
signal-event ibay-create fusionpbx

#Get the FQDN
dommain_name={hostname -d}

#Configure the subdomain
db domains set pbx.sipking.com domain Description "FusionPBX" Content Primary Nameservers \
internet TemplatePath WebAppVirtualHost DocumentRoot /opt/fusionpbx RequireSSL enabled

#Create the domain
signal-event domain-create pbx.$domain_name
signal-event webapps-update

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
