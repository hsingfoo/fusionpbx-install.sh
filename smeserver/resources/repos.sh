#!/bin/bash

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./colors.sh

verbose "${green}Installing and configuring Repositories${normal}"
echo ""
#Define yum repository for 9.4
verbose "PostgreSQL 9.4"
/sbin/e-smith/db yum_repositories set postgresql94 repository \
Name "PostgreSQL 9.4" \
BaseURL 'https://download.postgresql.org/pub/repos/yum/9.4/redhat/rhel-$releasever-$basearch' \
Visable no status disabled

#define yum repository for Freeswitch 6.x
verbose "Okay for Freeswitch 1.6"
/sbin/e-smith/db yum_repositories set okay repository \
BaseURL 'http://repo.okay.com.mx/centos/$releasever/$basearch/release'/ \
Name 'Extra OKay Packages for Enterprise Linux' \
EnableGroups no Visible no status disabled

#Define yum repository for EPEL
verbose "EPEL"
/sbin/e-smith/db yum_repositories set epel repository \
Name 'Epel - EL6' \
BaseURL 'http://download.fedoraproject.org/pub/epel/6/$basearch' \
MirrorList 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch' \
EnableGroups no \
GPGCheck yes \
GPGKey http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL \
Exclude perl-Razor-Agent \
Visible no status disabled

#Define yum repository for REMI
verbose "REMI"
/sbin/e-smith/db yum_repositories set remi repository \
Name 'Remi - EL6' \
BaseURL 'http://rpms.famillecollet.com/enterprise/6/remi/$basearch/' \
EnableGroups no \
GPGCheck yes \
GPGKey http://rpms.famillecollet.com/RPM-GPG-KEY-remi \
Visible yes \
Exclude mysql*,php-*,phpMyAdmin status disabled

#Define Centos SCL repository
verbose "CentOS SCL"
/sbin/e-smith/db yum_repositories set centos-sclo-rh repository \
Name 'Centos - RH Software Collections' \
BaseURL 'http://mirror.centos.org/centos/$releasever/sclo/$basearch/rh/' \
EnableGroups no \
Visible no status disabled

#Define NodeJS repository
verbose "NodeJS"
/sbin/e-smith/db yum_repositories set nodejs \
repository Name 'Node JS 4' \
BaseURL https://rpm.nodesource.com/pub_4.x/el/6/x86_64 \
EnableGroups no GPGCheck no Visible yes status disabled

#Define FWS repository
verbose "FWS"
/sbin/e-smith/db yum_repositories set fws repository \
BaseURL http://repo.firewall-services.com/centos/\$releasever \
EnableGroups no GPGCheck yes \
Name "Firewall Services" \
GPGKey http://repo.firewall-services.com/RPM-GPG-KEY \
Visible no status disabled

#Define IRONTEC repository
verbose "IRONTEC"
/sbin/e-smith/db yum_repositories set irontec repository \
BaseURL 'http://packages.irontec.com/centos/$releasever/$basearch/' \
EnableGroups no \
Name "irontec" \
Visible no status disabled

#Define cert-forensics-tools repository
verbose "cert-forensics-tools"
/sbin/e-smith/db yum_repositories set forensics repository \
BaseURL 'http://www.cert.org/forensics/repository/centos/cert/$releasever/$basearch' \
EnableGroups no \
Name "Cert Forensics Tools Repository" \
Visible no status disabled

verbose "Configuring and updating repositories, please wait..."
signal-event yum-modify
sleep 10
echo ""
verbose "Yum repositories updated."
echo ""