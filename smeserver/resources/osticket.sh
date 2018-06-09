#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

# move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./colors.sh
. ./config.sh

# Install and configure OSTicket
verbose "Installing and configuring OsTicket"

# Populate the accounts db with the new share details 
db accounts set $osticket_name share Name $osticket_name DynamicContent enabled Encryption disabled \
Indexes disabled Pydio disabled RecycleBin disabled RecycleBinRetention unlimited Removable no PHPVersion $php_version \
RequireSSL enabled WebDav disabled httpAccess local smbAccess none PHPBaseDir $osticket_path:/tmp \

db accounts setprop $osticket_name PHPDisabledFunctions 'system,show_source,symlink,exec,dl,passthru,phpinfo'
db accounts setprop $osticket_name PHPAllowUrlFopen on

# Create the OsTicket share
signal-event share-create $osticket_name

# Configure the subdomain and point to above shared folder
db domains set $osticket_subdomain.$domain_name domain Description OSTicket Nameservers localhost DocumentRoot $osticket_path Removable no TemplatePath WebAppVirtualHost

# Create the domain
signal-event domain-create $osticket_subdomain.$domain_name

# Provide a little time for previous processes are finished and/or closed, otherwise git will fail!
sleep 1

# Use full system path for if $osticket_path is empty, rm -Rf / will delete the whole server (been there, got the T-shirt ;) ) 
rm -Rf /home/e-smith/files/shares/$osticket_name/*

# Get OSTicket source code from github
git clone -b $osticket_version https://github.com/osTicket/osTicket.git $osticket_path
mkdir -p $osticket_path/attachments
chown admin:shared $osticket_path
chown -R www:www $osticket_path/*

# Create the MySQL database
mysql -e "create database $osticket_dbname";
mysql -e "grant all privileges on $osticket_dbname.* to $osticket_dbusername@localhost identified by '$osticket_dbpassword'";
mysql -e "flush privileges";

# Set the db key as configuration and properties
config set $osticket_name configuration name $osticket_dbname DBUserName $osticket_dbusername BPassword $osticket_dbpassword DBName $osticket_dbname
