#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

# Brand Server Manager
verbose "Branding"

#Server manager
mkdir -p /etc/e-smith/templates-custom/etc/e-smith/templates/etc/e-smith/web/common/foot.tmpl
mkdir -p /etc/e-smith/templates-custom/etc/e-smith/templates/etc/e-smith/web/common/head.tmpl
mkdir -p /etc/e-smith/templates-custom/etc/e-smith/templates/etc/e-smith/web/panels/manager/html/header.htm

cp branding/20ProductName /etc/e-smith/templates-custom/etc/e-smith/templates/etc/e-smith/web/common/foot.tmpl
cp branding/25Copyright /etc/e-smith/templates-custom/etc/e-smith/templates/etc/e-smith/web/common/foot.tmpl
cp branding/25ProductSMEServer /etc/e-smith/templates-custom/etc/e-smith/templates/etc/e-smith/web/common/foot.tmpl

cp branding/20Title /etc/e-smith/templates-custom/etc/e-smith/templates/etc/e-smith/web/common/head.tmpl
cp branding/30FrameSetup01 /etc/e-smith/templates-custom/etc/e-smith/templates/etc/e-smith/web/common/head.tmpl
cp branding/30FrameSetup02 /etc/e-smith/templates-custom/etc/e-smith/templates/etc/e-smith/web/common/head.tmpl

cp branding/10Head /etc/e-smith/templates-custom/etc/e-smith/templates/etc/e-smith/web/panels/manager/html/header.htm
cp branding/40LogoRow /etc/e-smith/templates-custom/etc/e-smith/templates/etc/e-smith/web/panels/manager/html/header.htm
cp branding/template-begin /etc/e-smith/templates-custom/etc/e-smith/templates/etc/e-smith/web/panels/manager/html/header.htm

# Set root permissions and ownership on custom templates
chown -R root:root /etc/e-smith/templates-custom/etc/e-smith/templates/etc/e-smith/web/*
chmod -R 0644 /etc/e-smith/templates-custom/etc/e-smith/templates/etc/e-smith/web/*

# Stamp
find /etc/e-smith/templates-custom/etc/e-smith/templates/etc/e-smith/web -type f -exec sed -i "s/product_name/$product_name/g" {} \;
find /etc/e-smith/templates-custom/etc/e-smith/templates/etc/e-smith/web -type f -exec sed -i "s/vendor_name/$vendor_name/g" {} \;
find /etc/e-smith/templates-custom/etc/e-smith/templates/etc/e-smith/web -type f -exec sed -i "s/copyright_label/$copyright_label/g" {} \;
find /etc/e-smith/templates-custom/etc/e-smith/templates/etc/e-smith/web -type f -exec sed -i "s/support_email/$support_email/g" {} \;
find /etc/e-smith/templates-custom/etc/e-smith/templates/etc/e-smith/web -type f -exec sed -i "s/vendorlogo_name/$vendor_logoname/g" {} \;

