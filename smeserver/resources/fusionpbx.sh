#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./colors.sh
. ./config.sh

#Set parameters UID for the new 'fusionpbx' ibay
#uid=`perl -Mesmith::AccountsDB -e 'my  $accountdb = esmith::AccountsDB->open(); print $accountdb->get_next_uid();'`

#Populate the accounts db with the new iBay details (access public, cgi enabled no password, SSL enabled)
#db accounts set $ibay_name ibay Name $ibay_name Group admin UserAccess wr-group-rd-everyone \
#Uid $uid Gid $uid CgiBin enabled PasswordSet no SSL enabled PublicAccess global \
#PHPBaseDir / \

#Populate the accounts db with the new share details 
db accounts set $share_name share Name $share_name DynamicContent enabled Encryption disabled \
Indexes disabled Pydio disabled RecycleBin disabled RecycleBinRetention unlimited \
RequireSSL enabled WebDav disabled httpAccess local smbAccess none PHPVersion '56' \

#Create the fusionpbx share
signal-event share-create $share_name

#Configure the subdomain and point to above ibay
db domains set $sub_domain.$domain_name domain Description "FusionPBX" Content $share_name Nameservers localhost \
DocumentRoot / Removable no \

#Create the domain
signal-event domain-create $sub_domain.$domain_name

#Install and configure FusionPBX
echo ""
verbose "Installing and configuring FusionPBX"

#Provide a little time for previous processes are finished and/or closed, otherwise git will fail!
sleep 1

#Use full system path for if www_path is empty, rm -Rf / will delete the whole server (been there, got the T-shirt ;) ) 
rm -Rf /home/e-smith/files/shares/$share_name/*

#git clone -b $fusion_version https://github.com/fusionpbx/fusionpbx.git $www_path
git clone -b $system_branch https://github.com/fusionpbx/fusionpbx.git $www_path
chown admin:shared $www_path
chown -R www:www $www_path/*
chmod -R 755 $www_path/secure

# Adjust some Debian assumptions to Generic/CentOS
sed -i 's/= "localhost"/= "127.0.0.1"/g' $www_path/core/install/resources/classes/install_fusionpbx.php
