#!/bin/bash


# Cloud settings
cloud_name=cloud													# Nextcloud
cloud_version=13.0.2												# Nextcloud version
cloud_branch=stable13
cloud_path=/home/e-smith/files/shares/$cloud_name/files				# full path to Nextcloud directory
cloud_datapath=$cloud_path/data
cloud_subdomain=cloud
cloud_dbname=nextcloud										# Nextcloud MySQL databasename
cloud_dbusername=nextclouduser										# Nextcloud MySQL username
cloud_dbpassword=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64 | sed 's/[=\+//]//g')
cloud_adminname=admin
cloud_adminpass=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64 | sed 's/[=\+//]//g')


cat <<HERE1 > $cloud_path/config/autoconfig.php
<?php
$AUTOCONFIG = array(
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
