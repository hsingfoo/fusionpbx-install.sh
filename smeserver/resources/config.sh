# Copyright H.F. Wang - hsingfoo@gmail.com.

# General Settings
php_version=71                   									# PHP version 56, 70 or 71
script_path=/usr/src/fusionpbx-install.sh							# Root path to install script
sme_version=9														# 9, 10
domain_name=$(hostname -d)											# Get the hostname
AUTO=-"y -q"														# Auto and quiet install

# Branding
product_name=BogusProduct												
vendor_name=BogusComapany
copyright_label=2018
support_email=support@boguscompany.org
vendorlogo_name=BogusImage.png

# PostgreSQL details
database_version=9.6												# 9.4 or 9.6
database_host=127.0.0.1												# Fixed setting
database_port=5432													# Fixed setting
database_username=fusionpbx											# FusionPBX PostgreSQL username
database_password=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64 | sed 's/[=\+//]//g')

# Cloud settings
cloud_name=cloud													# Nextcloud
cloud_version=13.0.2												# Nextcloud version
cloud_branch=stable13
cloud_path=/home/e-smith/files/shares/$cloud_name/files				# full path to Nextcloud directory
cloud_datapath=$cloud_path/data
cloud_subdomain=cloud												# Subdomain name
cloud_dbtype=mysql
cloud_dbhost=localhost
cloud_dbname=nextcloud												# Nextcloud MySQL databasename
cloud_dbusername=nextclouduser										# Nextcloud MySQL username
cloud_dbpassword=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64 | sed 's/[=\+//]//g')
cloud_adminname=admin
cloud_adminpass=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64 | sed 's/[=\+//]//g')

# FusionPBX / FreeSwitch settings
fusionpbx_name=fusionpbx											# Fusionpbx
fusionpbx_version=4.4												# FusionPBX branch version
fusionpbx_subdomain=tel												# FusionPBX sub domain. tel, pbx or anything
fusionpbx_path=/home/e-smith/files/shares/$fusionpbx_name/files		# full path to share files directory
switch_version=1.6.20-2            									# FreeSWITCH full version

# OsTicket settings
osticket_name=osticket
osticket_version=1.10.x
osticket_subdomain=support
osticket_path=/home/e-smith/files/shares/$osticket_name/files
osticket_dbname=osticket
osticket_dbpassword=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64 | sed 's/[=\+//]//g')
osticket_dbusername=osticketuser

# Wordpress setting
wp_document_root=/usr/share/wordpress
wp_name=wordpress
wp_path=/home/e-smith/files/shares/$wp_name/files

