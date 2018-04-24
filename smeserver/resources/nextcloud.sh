#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

verbose "Installing Nextcloud"

# Populate the accounts db with the new cloud details 
db accounts set $cloud_name share Name $cloud_name DynamicContent enabled Encryption disabled \
Indexes disabled Pydio disabled RecycleBin disabled RecycleBinRetention unlimited \
RequireSSL enabled WebDav disabled httpAccess local smbAccess none PHPVersion $php_version \
AllowOverride All FollowSymLinks enabled Group www \
PHPBaseDir $cloud_path:/tmp/:/dev/urandom \

# Create the cloud share
signal-event share-create $cloud_name

#Configure the subdomain and point to above shared folder
db domains set $cloud_subdomain.$domain_name domain Description "Nextcloud" Content $cloud_name Nameservers localhost \
DocumentRoot $cloud_path Removable no TemplatePath WebAppVirtualHost \

#Create the domain
signal-event domain-create $cloud_subdomain.$domain_name

#Use full system path for if cloud_path is empty, rm -Rf / will delete the whole server (been there, got the T-shirt ;) ) 
rm -Rf /home/e-smith/files/shares/$cloud_name/*

# Clone branch version of Nextcloud
git clone -b $cloud_branch https://github.com/nextcloud/server.git $cloud_path $DEBUG
chown admin:shared $cloud_path
chown -R www:www $cloud_path/*.*

# create MySQL database
mysql -e "create database $cloud_databasename";
mysql -e "grant all privileges on $cloud_databasename.* to $cloud_username@localhost identified by '$cloud_password'";
mysql -e "flush privileges";

# Store database credentials in Nextcloud db key
config set nextcloud configuration DatabaseName $cloud_databasename DatabaseUsername DatabasePassword $cloud_password


