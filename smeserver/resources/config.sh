# FusionPBX Settings
system_branch=master            					# master, stable

# FreeSWITCH Settings
switch_branch=master            					# master, stable
switch_source=false             					# true or false
switch_package=true             					# true or false

# General Settings
php_version=5                   					# PHP version 5 or 7
database_repo=official          					# PostgresSQL official
database_backup=false           					# true or false
web_server_name=apache          					# nginx, apache

# PostgreSQL details
database_version=9.6									# 9.4, 9.6
database_host=127.0.0.1
database_port=5432
database_username=fusionpbx

# SME Server settings
sme_version=9										# 9, 10
ibay_name=fusionpbx									# fusionpbx
sub_domain=tel										# tel
scl_enabled=true									# true or false
www_path=/home/e-smith/files/ibays/$ibay_name/html	# full path to ibay html directory
 