#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

#
verbose "Installing user-panel and user-panels, vacation, remoteuseraccess, wordpress, dehydrated and check4updates"
yum $AUTO install smeserver-userpanel smeserver-userpanels smeserver-vacation smeserver-remoteuseraccess smeserver-wordpress smeserver-check4updates --enablerepo=smecontribs,fws,epel
config setprop wordpress AllowOverrideAll All
# add Option +FollowSymLinks to .htaccess
# Todo
signal-event wordpress-update
signal-event conf-userpanel

# Populate the accounts db with the new wordpress details 
db accounts set $wp_name share Name $wp_name DynamicContent enabled Encryption disabled \
Indexes disabled Pydio disabled RecycleBin disabled RecycleBinRetention unlimited Removable no \
RequireSSL enabled WebDav disabled httpAccess local smbAccess none PHPVersion $php_version \
AllowOverride All FollowSymLinks enabled Group www \
PHPBaseDir $wp_path:/tmp/:/dev/urandom:/var/lib/php/$wp_name \

signal-event share-create $wp_name

# Have main domain point to wordpress
db domains setprop $domain_name TemplatePath WebAppVirtualHost DocumentRoot $wp_document_root
db domains delprop $domain_name Content
signal-event webapps-update

# Remove symbolic links and copy original files due to upgrades etc
rm -f /usr/share/wordpress/wp-includes/certificates/ca-bundle.crt
cp /etc/pki/tls/certs/ca-bundle.crt /usr/share/wordpress/wp-includes/certificates/ca-bundle.crt
rm -f /usr/share/wordpress/wp-includes/class-phpmailer.php
cp /usr/share/php/PHPMailer/class.phpmailer.php /usr/share/wordpress/wp-includes/class-phpmailer.php
rm -f /usr/share/wordpress/wp-includes/class-class-smtp.php
cp /usr/share/php/PHPMailer/class.smtp.php /usr/share/wordpress/wp-includes/class-smtp.php
rm -f /usr/share/wordpress/wp-includes/class-simplepie.php
cp /usr/share/php/php-simplepie/autoloader.php /usr/share/wordpress/wp-includes/class-simplepie.php
chown -R www:root $wp_document_root *
