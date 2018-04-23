#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./config.sh
. ./colors.sh

verbose "Installing various contribs"

# Repos
resources/repos.sh

# PHP-SCL
resources/php-scl.sh

# Haveged
resources/haveged.sh

# sngrep
resources/sngrep.sh

# memcached
rsources/memcached.sh

# Sogo3
resources/sogo3.sh

# SoftetherVPN
resources/SoftetherVPN.sh

# Fail2ban
resources/fail2ban.sh

# Clamav-unofficial Signatures
resources/clamav-unofficial-signatures.sh

# user-panel, user-panels, dehydrated, wordpress, vacation, chec4updates, remote-useraccess
resources/misc.sh

# Dokuwiki
resources/dokuwiki.sh

#Fail2ban
resources/fail2ban.sh

# Freeswitch
#FreeSWITCH
resources/switch/smeserver-freeswitch.sh



