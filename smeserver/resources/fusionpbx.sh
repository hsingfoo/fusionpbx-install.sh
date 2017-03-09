#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./colors.sh

#Set parameters for the new 'fusionpbx' ibay
uid=`perl -Mesmith::AccountsDB -e 'my  $accountdb = esmith::AccountsDB->open(); print $accountdb->get_next_uid();'`
ibay_name=fusionpbx
www_path=/home/e-smith/files/ibays/$ibay_name/html
sub_domain=tel
fusion_version=4.2

#Populate the accounts db with the new ibay details
db accounts set $ibay_name ibay Name fusionpbx Group admin UserAccess wr-group-rd-everyone \
Uid $uid Gid $uid CgiBin enabled PasswordSet no SSL enabled PublicAccess global \

#Create the fusionpbx ibay
signal-event ibay-create $ibay_name

#Get the FQDN
domain_name=$(hostname -d)

#Configure the subdomain and point to above ibay
db domains set tel.$domain_name domain Description "FusionPBX" Content $ibay_name Nameservers internet

#Create the domain
signal-event domain-create $sub_domain.$domain_name

#Install and configure FusionPBX
echo ""
verbose "Installing and configuring FusionPBX 4.2.x"

#Provide a little time for previous processes are finished and/or closed, otherwise git will fail!
sleep 1

rm -Rf $www_path/*
git clone -b $fusion_version https://github.com/fusionpbx/fusionpbx.git $www_path
chown admin:shared $www_path
chown -R www:www $www_path/*

# Adjust some Debian assumptions to Generic/CentOS
sed -i 's/= "localhost"/= "127.0.0.1"/g' $www_path/core/install/resources/classes/install_fusionpbx.php
