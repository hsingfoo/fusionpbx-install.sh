#!/bin/sh

verbose () {
	echo "${green}$1${normal}"
}
error	() {
	echo "${red}$1${normal}"
}

# check for color support
if test -t 1; then

    # see if it supports colors...
    ncolors=$(tput colors)

    if test -n "$ncolors" && test $ncolors -ge 8; then
        bold="$(tput bold)"
        underline="$(tput smul)"
        standout="$(tput smso)"
        normal="$(tput sgr0)"
        black="$(tput setaf 0)"
        red="$(tput setaf 1)"
        green="$(tput setaf 2)"
        yellow="$(tput setaf 3)"
        blue="$(tput setaf 4)"
        magenta="$(tput setaf 5)"
        cyan="$(tput setaf 6)"
        white="$(tput setaf 7)"
    fi
	verbose "Enabled color support"
fi

# check to confirm running as root.
if [ "$(id -u)" -ne "0" ]; then
	error "$(basename "$0") must be run as root";
	exit 1
fi

#Make ourselves executable next time we are run
chmod +x $0

#Architecture check
if [ `getconf LONG_BIT` = "32" ]
then
    echo "32-bit systems are not supported. Exiting."
exit
fi

# Get the rest of the scripts
if [ ! -d /usr/src ]; then
	mkdir -vp /usr/src
fi
cd /usr/src
verbose "Fetching Installer"
if [ -d /usr/src/fusionpbx-install.sh ]; then
	cd /usr/src/fusionpbx-install.sh
	git pull
else
	git clone https://github.com/hsingfoo/fusionpbx-install.sh
fi

#start script
