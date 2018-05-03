#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

# move to script directory so all relative paths work
cd "$(dirname "$0")"

# includes
. ./config.sh
. ./colors.sh

# Create templates for HTTP HSTS
./hsts.sh

# Install and configure Redis
./redis.sh

# Install and configure memcached
./memcached.sh
verbose "Installing and configuring Nextcloud"
# Populate the accounts db with the new cloud details 
db accounts set $cloud_name share Name $cloud_name DynamicContent enabled Encryption disabled \
Indexes disabled Pydio disabled RecycleBin disabled RecycleBinRetention unlimited Removable no \
RequireSSL enabled WebDav disabled httpAccess local smbAccess none PHPVersion $php_version \
AllowOverride All FollowSymLinks enabled Group www \
PHPBaseDir $cloud_path:/tmp/:/dev/urandom \

# Create the cloud share
signal-event share-create $cloud_name

# Configure the subdomain and point to above shared folder
db domains set $cloud_subdomain.$domain_name domain Description $cloud_name Nameservers localhost \
DocumentRoot $cloud_path Removable no TemplatePath WebAppVirtualHost \

# Create the domain
signal-event domain-create $cloud_subdomain.$domain_name

# Provide a little time for previous processes are finished and/or closed, otherwise git will fail!
sleep 1

# Use full system path for if cloud_path is empty, rm -Rf / will delete the whole server (been there, got the T-shirt ;) ) 
rm -Rf /home/e-smith/files/shares/$cloud_name/*

# Clone branch version of Nextcloud
git clone -q -b $cloud_branch https://github.com/nextcloud/server.git $cloud_path

# get 3rdparty modules
cd $cloud_path
git submodule --quiet update --init
cd "$(dirname "$0")"

# Auto configure file for Nextcloud
cat <<HERE1 > $cloud_path/config/autoconfig.php
<?php
\$AUTOCONFIG = array(
  "dbtype"        => "$cloud_dbtype",
  "dbname"        => "$cloud_dbname",
  "dbuser"        => "$cloud_dbusername",
  "dbpass"        => "$cloud_dbpassword",
  "dbhost"        => "$cloud_dbhost",
  "dbtableprefix" => "nc_",
  "adminlogin"    => "$cloud_adminname",
  "adminpass"     => "$cloud_adminpass",
  "directory"     => "$cloud_datapath",
);
HERE1

# Set permissions
mkdir -p $cloud_datapath
chown admin:shared $cloud_path
chown -R www:www $cloud_path *

# Set correct opcache and apcu values
sed -i "s|;opcache.enable_cli=0|opcache.enable_cli=1|" /etc/opt/remi/php$php_version/php.d/10-opcache.ini
sed -i "s|opcache.max_accelerated_files=4000|opcache.max_accelerated_files=10000|" /etc/opt/remi/php$php_version/php.d/10-opcache.ini
sed -i "s|;opcache.revalidate_freq=2|opcache.revalidate_freq=1|" /etc/opt/remi/php$php_version/php.d/10-opcache.ini
sed -i "s|;opcache.save_comments=1|opcache.save_comments=1|" /etc/opt/remi/php$php_version/php.d/10-opcache.ini
sed -i "s|;apc.enable_cli=0|;apc.enable_cli=1|" /etc/opt/remi/php$php_version/php.d/40-apcu.ini

service php$php_version-php-fpm start

# create MySQL database
mysql -e "create database $cloud_dbname";
mysql -e "grant all privileges on $cloud_dbname.* to $cloud_dbusername@localhost identified by '$cloud_dbpassword'";
mysql -e "flush privileges";

# Store Nextcloud credentials in nextcloud db key
config set nextcloud configuration DatabaseName $cloud_dbname DatabaseUsername $cloud_dbusername DatabasePassword $cloud_dbpassword AdminName $cloud_adminname AdminPass $cloud_adminpass

# Create seperate config files for additional parameters (xxx.config.php).
# For Redis, setenforce 0 has to bet set, otherwise redis will die on file uploads.

cat <<HERE2 > $cloud_path/config/baserewrite.config.php
<?php
\$CONFIG = array (
	'htaccess.RewriteBase' => '$cloud_path',
);
HERE2

cat <<HERE3 > $cloud_path/config/apcucache.config.php
<?php
\$CONFIG = array (
	'memcache.local' => '\OC\Memcache\APCu',
);
HERE3

# Add subdomain to trusted domains. Only cloud_dbhost will get listed by default
cat <<HERE4 > $cloud_path/config/trusteddomains.config.php
<?php
\$CONFIG = array (
	'trusted_domains' => 
	array (
    '$cloud_subdomain.$domain_name',
	),
);
HERE4

# Set strict permissions on config files
chmod 0640 $cloud_path/config/*
chown www:www $cloud_path/config/*

# Initialize (install) Nextcloud for the first time in the background
cat <<HERE5 > $script_path/smeserver/resources/nextcloud_init.sh
cd $cloud_path
php occ maintenance:install --database $cloud_dbtype --database-host $cloud_dbhost \
--database-name $cloud_dbname --database-user $cloud_dbusername --database-pass $cloud_dbpassword \
--admin-user $cloud_adminname --admin-pass $cloud_adminpass
HERE5
chmod 755 $script_path/smeserver/resources/nextcloud_init.sh

