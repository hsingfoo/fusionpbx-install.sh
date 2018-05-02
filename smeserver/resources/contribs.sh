#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./config.sh
. ./colors.sh

# SharedFolders
./sharedfolders.sh

# Lemon-LDAP-ng
./lemon-ldap-ng.sh

# Redis
./redis.sh

# HTTP HSTS
./hsts.sh

# Haveged
./haveged.sh

# sngrep
./sngrep.sh

# memcached **MUST** be installed BEFORE Sogo
./memcached.sh

# Sogo3
./sogo3.sh

# SoftetherVPN
./SoftetherVPN.sh

# Clamav-unofficial Signatures
./clamav-unofficial-signatures.sh

# user-panel, user-panels, dehydrated, wordpress, vacation, chec4updates, remote-useraccess
./misc.sh

# Dokuwiki
./dokuwiki.sh

# Affa
./affa.sh

# BackupPC
./backuppc.sh

# TFTP Server
./tftpserver.sh

# PHPList
./phplist.sh

# LimeSurvey
./limesurvey.sh

# Crontab Manager
./crontabmanager.sh

# Webfilter
./webfilter.sh

#PostgreSQL
./postgres.sh

# Freeswitch
./smeserver-freeswitch.sh

# Fail2ban, needs to be installed after all other contribs due to dependencies on log files being present
#./fail2ban.sh




