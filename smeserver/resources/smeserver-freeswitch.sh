#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

# move to script directory so all relative paths work
cd "$(dirname "$0")"

# Includes
. ./config.sh
. ./colors.sh

# Call PostgreSQL script
./postgres.sh

verbose "Installing and configuring ffmpeg"
yum $AUTO install ffmpeg ghostscript ilbc2 sox --enablerepo=okay,epel
verbose "Installing and configuring Freeswitch $switch_version"
yum $AUTO install *$switch_version* freeswitch-sounds-en-us-callie-all freeswitch-sounds-music --enablerepo=okay,epel,remi-safe

# Remove the music package to protect music on hold from package updates
mkdir -p /usr/share/freeswitch/sounds/temp
mv /usr/share/freeswitch/sounds/music/*000 /usr/share/freeswitch/sounds/temp
yum $AUTO remove freeswitch-sounds-music
mkdir -p /usr/share/freeswitch/sounds/music/default
mv /usr/share/freeswitch/sounds/temp/* /usr/share/freeswitch/sounds/music/default
rm -Rf /usr/share/freeswitch/sounds/temp  > /dev/null 2>&1

# Create SME Server service
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S99freeswitch
config set freeswitch service 
config setprop freeswitch status enabled
config setprop freeswitch access public
config setprop freeswitch UDPPorts "5060:5061,5080:5081,8081,8082,16384:32768"
config setprop freeswitch TCPPorts "5060:5061,5080:5081,8081,8082"

# Create custom template for IP tables rules for Freeswitch
mkdir -p /etc/e-smith/templates-custom/etc/rc.d/init.d/masq/
cat <<HERE2 > /etc/e-smith/templates-custom/etc/rc.d/init.d/masq/40Freeswitch
iptables -A INPUT -j DROP -p udp --dport 5060:5061 -m string --string "friendly-scanner" --algo bm
iptables -A INPUT -j DROP -p udp --dport 5060:5061 -m string --string "sipcli/" --algo bm
iptables -A INPUT -j DROP -p udp --dport 5060:5061 -m string --string "VaxSIPUserAgent/" --algo bm
iptables -A INPUT -j DROP -p tcp --dport 5060:5061 -m string --string "friendly-scanner" --algo bm
iptables -A INPUT -j DROP -p tcp --dport 5060:5061 -m string --string "sipcli/" --algo bm
iptables -A INPUT -j DROP -p tcp --dport 5060:5061 -m string --string "VaxSIPUserAgent/" --algo bm
iptables -A INPUT -j DROP -p udp --dport 5080:5081 -m string --string "friendly-scanner" --algo bm
iptables -A INPUT -j DROP -p udp --dport 5080:5081 -m string --string "sipcli/" --algo bm
iptables -A INPUT -j DROP -p udp --dport 5080:5081 -m string --string "VaxSIPUserAgent/" --algo bm
iptables -A INPUT -j DROP -p tcp --dport 5080:5081 -m string --string "friendly-scanner" --algo bm
iptables -A INPUT -j DROP -p tcp --dport 5080:5081 -m string --string "sipcli/" --algo bm
iptables -A INPUT -j DROP -p tcp --dport 5080:5081 -m string --string "VaxSIPUserAgent/" --algo bm
HERE2

#Expand the template and restart masq
/sbin/e-smith/expand-template /etc/rc.d/init.d/masq
/etc/init.d/masq restart

#Add user freeswitch to the www group and www to daemon group
usermod -a -G www freeswitch
usermod -a -G daemon www

