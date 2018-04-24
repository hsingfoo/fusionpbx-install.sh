#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

verbose "Installing BackupPC"
yum $AUTO --enablerepo=smecontribs install smeserver-BackupPC
signal-event backuppc-update
