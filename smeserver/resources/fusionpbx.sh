#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./colors.sh
. ./config.sh

#Set parameters for the new 'fusionpbx' ibay
uid=`perl -Mesmith::AccountsDB -e 'my  $accountdb = esmith::AccountsDB->open(); print $accountdb->get_next_uid();'`

#Populate the accounts db with the new ibay details (access public, cgi enabled no password, SSL enabled)
db accounts set $ibay_name ibay Name fusionpbx Group admin UserAccess wr-group-rd-everyone \
Uid $uid Gid $uid CgiBin enabled PasswordSet no SSL enabled PublicAccess global \
PHPBaseDir / \

#Create the fusionpbx ibay
signal-event ibay-create $ibay_name

#Configure the subdomain and point to above ibay
db domains set $sub_domain.$domain_name domain Description "FusionPBX" Content $ibay_name Nameservers internet

#Create the domain
signal-event domain-create $sub_domain.$domain_name

#Install and configure FusionPBX
echo ""
verbose "Installing and configuring FusionPBX"

#Provide a little time for previous processes are finished and/or closed, otherwise git will fail!
sleep 1

#Use full system path for if www_path is empty, rm -Rf / will delete the whole server (been there, got the T-shirt ;) ) 
rm -Rf /home/e-smith/files/ibays/$ibay_name/html/*

#git clone -b $fusion_version https://github.com/fusionpbx/fusionpbx.git $www_path
git clone -b $system_branch https://github.com/fusionpbx/fusionpbx.git $www_path
chown admin:shared $www_path
chown -R www:www $www_path/*
chmod -R 755 $www_path/secure

# Adjust some Debian assumptions to Generic/CentOS
sed -i 's/= "localhost"/= "127.0.0.1"/g' $www_path/core/install/resources/classes/install_fusionpbx.php
