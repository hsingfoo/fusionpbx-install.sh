#!/bin/bash
#Define yum repository for 9.4
echo "PostgreSQL 9.4"
/sbin/e-smith/db yum_repositories set postgresql94 repository \
Name "PostgreSQL 9.4" \
BaseURL 'https://download.postgresql.org/pub/repos/yum/9.4/redhat/rhel-$releasever-$basearch' \
Visable no status disabled

#define yum repository for Freeswitch 6.x
echo "Okay for Freeswitch 1.6"
/sbin/e-smith/db yum_repositories set okay repository \
BaseURL 'http://repo.okay.com.mx/centos/$releasever/$basearch/release'/ \
Name 'Extra OKay Packages for Enterprise Linux' \
EnableGroups no Visible no status disabled

#Define yum repository for EPEL
echo "EPEL"
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
echo "REMI"
/sbin/e-smith/db yum_repositories set remi repository \
Name 'Remi - EL6' \
BaseURL 'http://rpms.famillecollet.com/enterprise/6/remi/$basearch/' \
EnableGroups no \
GPGCheck yes \
GPGKey http://rpms.famillecollet.com/RPM-GPG-KEY-remi \
Visible yes \
Exclude mysql*,php-*,phpMyAdmin status disabled

#Define Centos SCL repository
echo "CentOS SCL"
/sbin/e-smith/db yum_repositories set centos-sclo-rh repository \
Name 'Centos - RH Software Collections' \
BaseURL 'http://mirror.centos.org/centos/$releasever/sclo/$basearch/rh/' \
EnableGroups no \
Visible no status disabled

#Define NodeJS repository
echo "NodeJS"
/sbin/e-smith/db yum_repositories set nodejs \
repository Name 'Node JS 4' \
BaseURL https://rpm.nodesource.com/pub_4.x/el/6/x86_64 \
EnableGroups no GPGCheck no Visible yes status disabled

#Define FWS repository
echo "FWS"
/sbin/e-smith/db yum_repositories set fws repository \
BaseURL http://repo.firewall-services.com/centos/\$releasever \
EnableGroups no GPGCheck yes \
Name "Firewall Services" \
GPGKey http://repo.firewall-services.com/RPM-GPG-KEY \
Visible no status disabled

#Define IRONTEC repository
echo “IRONTEC”
/sbin/e-smith/db yum_repositories set irontec repository \
BaseURL 'http://packages.irontec.com/centos/$releasever/$basearch/' \
EnableGroups no GPGCheck yes \
Name "irontec" \
Visible no status disabled

#Define cert-forensics-tools repository
echo “cert-forensics-tools”
/sbin/e-smith/db yum_repositories set forensics repository \
BaseURL 'http://www.cert.org/forensics/repository/centos/cert/$releasever/$basearch' \
EnableGroups no \
Name "Cert Forensics Tools Repository" \
Visible no status disabled

echo "reconfiguring yum database"
signal-event yum-modify
echo "Yum repositories updated."
exit
