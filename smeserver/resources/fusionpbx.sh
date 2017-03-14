#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./colors.sh
. ./config.sh

#Set parameters for the new 'fusionpbx' ibay
uid=`perl -Mesmith::AccountsDB -e 'my  $accountdb = esmith::AccountsDB->open(); print $accountdb->get_next_uid();'`
ibay_name=fusionpbx
fusion_version=4.2
www_path=/home/e-smith/files/ibays/$ibay_name/html
sub_domain=tel

#Populate the accounts db with the new ibay details (access public, cgi enabled no password, SSL enabled)
db accounts set $ibay_name ibay Name fusionpbx Group admin UserAccess wr-group-rd-everyone \
Uid $uid Gid $uid CgiBin enabled PasswordSet no SSL enabled PublicAccess global \
PHPBaseDir / \

#Create the fusionpbx ibay
signal-event ibay-create $ibay_name

#Get the FQDN
domain_name=$(hostname -d)

#Configure the subdomain and point to above ibay
db domains set $sub_domain.$domain_name domain Description "FusionPBX" Content $ibay_name Nameservers internet

#Create the domain
signal-event domain-create $sub_domain.$domain_name

#Install and configure FusionPBX
echo ""
verbose "Installing and configuring FusionPBX"
if [ .$system_branch = "master" ]; then
	verbose "Using master"
	branch=""
else
	system_major=$(git ls-remote --heads https://github.com/fusionpbx/fusionpbx.git | cut -d/ -f 3 | grep -P '^\d+\.\d+' | sort | tail -n 1 | cut -d. -f1)
	system_minor=$(git ls-remote --tags https://github.com/fusionpbx/fusionpbx.git $system_major.* | cut -d/ -f3 |  grep -P '^\d+\.\d+' | sort | tail -n 1 | cut -d. -f2)
	system_version=$system_major.$system_minor
	verbose "Using version $system_version"
	branch="-b $system_version"
fi

#Provide a little time for previous processes are finished and/or closed, otherwise git will fail!
sleep 1

#Use full system path for if www_path is empty, rm -Rf / will delete the whole server (been there, got the T-shirt ;) ) 
rm -Rf /home/e-smith/files/ibays/$ibay_name/html/*

#git clone -b $fusion_version https://github.com/fusionpbx/fusionpbx.git $www_path
git clone https://github.com/fusionpbx/fusionpbx.git $www_path
chown admin:shared $www_path
chown -R www:www $www_path/*
chmod -R 755 $www_path/secure

# Adjust some Debian assumptions to Generic/CentOS
sed -i 's/= "localhost"/= "127.0.0.1"/g' $www_path/core/install/resources/classes/install_fusionpbx.php
