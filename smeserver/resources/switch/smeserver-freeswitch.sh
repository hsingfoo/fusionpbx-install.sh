#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ../config.sh
. ../colors.sh

echo ""
verbose "Installing and configuring Freeswitch 1.6, please wait..."
yum -y -q -d 0 -e 0 install ffmpeg lame ghostscript ilbc2 --enablerepo=okay,epel
yum -y -q -d 0 -e 0 install *$switch_version* freeswitch-sounds-en-us-callie-all freeswitch-sounds-music --enablerepo=okay,epel,remi > /dev/null 2>&1

#remove the music package to protect music on hold from package updates
mkdir -p /usr/share/freeswitch/sounds/temp
mv /usr/share/freeswitch/sounds/music/*000 /usr/share/freeswitch/sounds/temp
yum -y -q remove freeswitch-sounds-music
mkdir -p /usr/share/freeswitch/sounds/music/default
mv /usr/share/freeswitch/sounds/temp/* /usr/share/freeswitch/sounds/music/default
rm -Rf /usr/share/freeswitch/sounds/temp  > /dev/null 2>&1

#create SME Server service
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S99freeswitch
config set freeswitch service 
config setprop freeswitch status enabled
config setprop freeswitch access public
config setprop freeswitch UDPPorts "5060:5061,5080:5081,8081,8082,16384:32768"
config setprop freeswitch TCPPorts "5060:5061,5080:5081,8081,8082"
signal-event remoteaccess-update

#Add user freeswitch to the www group
usermod -a -G www freeswitch
