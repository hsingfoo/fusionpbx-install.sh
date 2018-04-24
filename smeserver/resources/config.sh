# Copyright H.F. Wang - hsingfoo@gmail.com.

# General Settings
php_version=71                   						# PHP version 54, 55, 56, 70 or 71
script_path=/usr/src/fusionpbx-install.sh				# Root path to install script
sme_version=9											# 9, 10
domain_name=$(hostname -d)								# Get the hostname
AUTO=-y													# Auto install all YUM commands
DEBUG=2>/dev/null										# 2>/dev/null or ""

# PostgreSQL details
database_version=9.6									# 9.4 or 9.6
database_host=127.0.0.1
database_port=5432
database_username=fusionpbx
database_password=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64 | sed 's/[=\+//]//g')

# Cloud settings
cloud_name=cloud										# Nextcloud
cloud_branch=13.01										# Nextcloud version
cloud_path=/home/e-smith/files/shares/$cloud_name/files	# full path to Nextcloud directory
cloud_databasename=nextcloud
cloud_username=nextclouduser
cloud_password=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64 | sed 's/[=\+//]//g')

# FusionPBX / FreeSwitch settings
share_name=fusionpbx									# Fusionpbx
fusion_version=4.4										# FusionPBX branch version
sub_domain=tel											# FusionPBX sub domain. tel, pbx or anything
www_path=/home/e-smith/files/shares/$share_name/files	# full path to share files directory
switch_version=1.6.20-1            						# full version
