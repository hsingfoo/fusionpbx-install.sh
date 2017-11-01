#!/bin/bash

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./colors.sh
. ./config.sh

#Create custom template !!! for virtual host and alias fusionpbx
echo ""
verbose "Creating Sub-domain"

# How to set the correct domain via a variable???
yum -y install smeserver-webapps-common --enablerepo=fws

#Configure the subdomain
db domains set $sub_domain.$domain domain Description "$ibay_name" Content Primary Nameservers \
internet TemplatePath WebAppVirtualHost DocumentRoot $www_path RequireSSL enabled

#Create the domain
signal-event domain-create $sub_domain.$domain
signal-event webapps-update

#mkdir -p /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf
#cat <<HERE2 > /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf/fusionpbx

#<Directory /opt/fusionpbx>
#    SSLRequireSSL
#    AddType application/x-httpd-php .php
#    php_admin_value open_basedir /
#   php_admin_flag allow_url_fopen on
#    php_admin_flag allow_override all
#   php_admin_flag followsymlinks enabled
#   AllowOverride None
#   Options None
#   Options +Indexes
#    Options +Includes
#    AllowOverride None
#    order deny,allow
#    deny from all
#    allow from all
#</Directory>
#HERE2

#Point the primary domain website to the fusionpbx ibay
db domains setprop $domain Content $ibay_name
signal-event domain-modify $domain

#Expand httpd.conf and restart httpd-e-smith (already included in modify domain event above?)
expand-template /etc/httpd/conf/httpd.conf
service httpd-e-smith restart
