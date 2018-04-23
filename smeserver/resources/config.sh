# Copyright H.F. Wang - hsingfoo@gmail.com.
# FusionPBX Settings
system_branch=4.4            							# master, e.g. 4.4, or master

# FreeSWITCH Settings
switch_version=1.6.20-1            						# full version

# General Settings
php_version=56                   						# PHP version 54, 55, 56, 70 or 71
database_repo=official          						# PostgresSQL official
database_backup=false           						# true or false
web_server_name=apache          						# nginx, apache

# PostgreSQL details
database_version=9.6									# 9.4 or 9.6
database_host=127.0.0.1
database_port=5432
database_username=fusionpbx
database_password=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64 | sed 's/[=\+//]//g')

# SME Server settings
sme_version=9											# 9, 10
share_name=fusionpbx									# fusionpbx
fusion_version=4.4
sub_domain=tel											# tel, pbx or anything
scl_enabled=true										# true or false
www_path=/home/e-smith/files/shares/$share_name/files	# full path to share files directory

#Get the FQDN
domain_name=$(hostname -d)

#Set YUM auto install vaiable
AUTO=-y

 
