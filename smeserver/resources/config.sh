# Copyright H.F. Wang - hsingfoo@gmail.com

# FusionPBX Settings
system_branch=master            					# master, 4.2.2 

# FreeSWITCH Settings
switch_version=1.6.19-1            					# full version

# General Settings
php_version=5                   					# PHP version 5 or 7
database_repo=official          					# PostgresSQL official
database_backup=false           					# true or false
web_server_name=apache          					# nginx, apache

# PostgreSQL details
database_version=9.4								# 9.4, 9.6
database_host=127.0.0.1
database_port=5432
database_username=fusionpbx
database_password=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64 | sed 's/[=\+//]//g')
#database_password=supersecret # for debugging, all passwords the same

# SME Server settings
sme_version=9										# 9, 10
ibay_name=fusionpbx									# fusionpbx
fusion_version=4.2
sub_domain=tel										# tel
scl_enabled=true									# true or false
www_path=/home/e-smith/files/ibays/$ibay_name/html	# full path to ibay html directory
#Get the FQDN
domain_name=$(hostname -d)

 