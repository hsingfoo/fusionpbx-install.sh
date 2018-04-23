#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./config.sh
. ./colors.sh

verbose "Installing various contribs"
pwd 

# SharedFolders
.sharedfolders.sh

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

#Fail2ban
./fail2ban.sh

#Affa
./affa.sh

# Freeswitch
/switch/smeserver-freeswitch.sh



