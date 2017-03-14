#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./config.sh
. ./colors.sh

#send a message
verbose "Configuring IPTables"

#Create custom template fragment
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
