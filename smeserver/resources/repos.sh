#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

echo ""
verbose "Configuring and updating repositories"
#Define yum repository for 9.4
/sbin/e-smith/db yum_repositories set postgresql94 repository \
Name "PostgreSQL 9.4" \
BaseURL 'http://yum.postgresql.org/9.4/redhat/rhel-$releasever-$basearch' \
Visable no \
status disabled

#Define yum repository for 9.6
/sbin/e-smith/db yum_repositories set postgresql96 repository \
Name "PostgreSQL 9.6" \
BaseURL 'http://yum.postgresql.org/9.6/redhat/rhel-$releasever-$basearch' \
Visable no \
status disabled

#define yum repository for Freeswitch 6.x
/sbin/e-smith/db yum_repositories set okay repository \
BaseURL 'http://repo.okay.com.mx/centos/$releasever/$basearch/release'/ \
Name 'Extra OKay Packages for Enterprise Linux' \
EnableGroups no \
Visible no \
status disabled

#Define yum repository for EPEL
/sbin/e-smith/db yum_repositories set epel repository \
Name 'Epel - EL6' \
BaseURL 'http://download.fedoraproject.org/pub/epel/6/$basearch' \
MirrorList 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch' \
EnableGroups no \
GPGCheck yes \
GPGKey http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL \
Exclude perl-Razor-Agent \
Visible no \
status disabled

#Define yum repository for REMI-SAFE
/sbin/e-smith/db yum_repositories set remi-safe repository \
Name 'Remi - safe' \
BaseURL 'http://rpms.famillecollet.com/enterprise/$releasever/safe/$basearch/' \
EnableGroups no \
GPGCheck yes \
GPGKey http://rpms.famillecollet.com/RPM-GPG-KEY-remi \
Visible no \
status disabled

#Define Centos SCL repository
/sbin/e-smith/db yum_repositories set centos-sclo-rh repository \
Name 'Centos - RH Software Collections' \
BaseURL 'http://mirror.centos.org/centos/$releasever/sclo/$basearch/rh/' \
EnableGroups no \
Visible no \
status disabled

#Define NodeJS repository
/sbin/e-smith/db yum_repositories set nodejs \
repository Name 'Node JS 4' \
BaseURL https://rpm.nodesource.com/pub_4.x/el/6/x86_64 \
EnableGroups no \
GPGCheck no \
Visible yes \
status disabled

#Define FWS repository
/sbin/e-smith/db yum_repositories set fws repository \
BaseURL http://repo.firewall-services.com/centos/\$releasever \
EnableGroups no GPGCheck yes \
Name "Firewall Services" \
GPGKey http://repo.firewall-services.com/RPM-GPG-KEY \
Visible no \
status disabled

#Define IRONTEC repository
/sbin/e-smith/db yum_repositories set irontec repository \
BaseURL 'http://packages.irontec.com/centos/$releasever/$basearch/' \
EnableGroups no \
Name "irontec" \
Visible no \
status disabled

#Define cert-forensics-tools repository
/sbin/e-smith/db yum_repositories set forensics repository \
BaseURL 'http://www.cert.org/forensics/repository/centos/cert/$releasever/$basearch' \
EnableGroups no \
Name "Cert Forensics Tools Repository" \
Visible no \
status disabled

#Define stephdl repository
db yum_repositories set stephdl repository \
BaseURL http://mirror.de-labrusse.fr/smeserver/\$releasever \
EnableGroups no GPGCheck yes \
Name "Mirror de Labrusse" \
GPGKey http://mirror.de-labrusse.fr/RPM-GPG-KEY \
Visible no \
status disabled

#Define sogo3 repository
db yum_repositories set sogo3 repository \
BaseURL http://packages.inverse.ca/SOGo/nightly/3/rhel/6/\$basearch \
EnableGroups yes \
GPGCheck no \
Name "Inverse SOGo Repository" \
Visible yes \
IncludePkgs gnustep-base,gnustep-make,libmemcached,libwbxml,sogo*,sope49* \
status disabled

signal-event yum-modify
sleep 4

