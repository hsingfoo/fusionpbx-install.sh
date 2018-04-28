#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./colors.sh
. ./config.sh

#Populate the accounts db with the new share details 
db accounts set $fusionpbx_name share Name $fusionpbx_name DynamicContent enabled Encryption disabled \
Indexes disabled Pydio disabled RecycleBin disabled RecycleBinRetention unlimited \
RequireSSL enabled WebDav disabled httpAccess local smbAccess none PHPVersion $php_version PHPBaseDir '/' \ 

#Create the fusionpbx share
signal-event share-create $fusionpbx_name

#Configure the subdomain and point to above shared folder
db domains set $fusionpbx_subdomain.$domain_name domain Description FusionPBX Nameservers localhost DocumentRoot $fusionpbx_path Removable no TemplatePath WebAppVirtualHost

#Create the domain
signal-event domain-create $fusionpbx_subdomain.$domain_name

#Install and configure FusionPBX
echo ""
verbose "Installing and configuring FusionPBX"

#Provide a little time for previous processes are finished and/or closed, otherwise git will fail!
sleep 1

#Use full system path for if www_path is empty, rm -Rf / will delete the whole server (been there, got the T-shirt ;) ) 
rm -Rf /home/e-smith/files/shares/$fusionpbx_name/*

#git clone -b $fusion_version https://github.com/fusionpbx/fusionpbx.git $www_path
git clone -b $fusionpbx_version https://github.com/fusionpbx/fusionpbx.git $fusionpbx_path
chown admin:shared $fusionpbx_path
chown -R www:www $fusionpbx_path/*
chmod -R 755 $fusionpbx_path/secure

# Adjust some Debian assumptions to Generic/CentOS
sed -i 's/= "localhost"/= "127.0.0.1"/g' $fusionpbx_path/core/install/resources/classes/install_fusionpbx.php
