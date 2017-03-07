#!/bin/bash

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./colors.sh

#Create custom template !!! for virtual host and alias fusionpbx
echo ""
verbose "Creating Sub-domain"
# How to set the correct domain via a variable???
yum -y -q install smeserver-webapps-common --enablerepo=fws
db domains set pbx.sipking.com domain Description "FusionPBX" Content Primary Nameservers \
internet TemplatePath WebAppVirtualHost DocumentRoot /opt/fusionpbx RequireSSL enabled
signal-event domain-create pbx.sipking.com
signal-event webapps-update


mkdir -p /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf
cat <<HERE2 > /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf/fusionpbx
<Directory /opt/fusionpbx>
    SSLRequireSSL
    AddType application/x-httpd-php .php
    php_admin_value open_basedir /
    php_admin_flag allow_url_fopen on
    php_admin_flag allow_override all
    php_admin_flag followsymlinks enabled
    AllowOverride None
    Options None
    Options +Indexes
    Options +Includes
    AllowOverride None
    order deny,allow
    deny from all
    allow from all
</Directory>
HERE2

#Expand httpd.conf and restart httpd-e-smith
expand-template /etc/httpd/conf/httpd.conf
service httpd-e-smith restart
echo ""
verbose "Sub-domain created"
