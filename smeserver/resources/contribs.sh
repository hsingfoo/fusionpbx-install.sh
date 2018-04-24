#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./config.sh
. ./colors.sh

verbose "Installing various contribs"

# SharedFolders
./sharedfolders.sh

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

# Fail2ban
./fail2ban.sh

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

# Crontab Manager
./crontabmanager.sh

# Nextcloud
#./nextcloud.sh

#PostgreSQL
./postgres.sh

# Freeswitch
$script_path/smeserver/resources/switch/smeserver-freeswitch.sh



