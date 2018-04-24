#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Includes
. ./config.sh
. ./colors.sh

# Installing SoftEtherVPN
#
echo Install Softether VPN
db portforward_tcp set 1194 forward Comment 'SoftEther OpenVPN' DestHost localhost DestPort 1194 AllowHosts ' ' DenyHosts ' '
db portforward_tcp set 5555 forward Comment 'SoftEther Management' DestHost localhost DestPort 5555 AllowHosts ' ' DenyHosts ' '
db portforward_udp set 1194 forward Comment 'SoftEther OpenVPN' DestHost localhost DestPort 1194 AllowHosts ' ' DenyHosts ' '
db portforward_udp set 500 forward Comment 'SoftEther SoftEther L2TP/IPSec' DestHost localhost DestPort 500 AllowHosts ' ' DenyHosts ' '
db portforward_udp set 1701 forward Comment 'SoftEther SoftEther L2TP/IPSec' DestHost localhost DestPort 1701 AllowHosts ' ' DenyHosts ' '
db portforward_udp set 4500 forward Comment 'SoftEther SoftEther L2TP/IPSec' DestHost localhost DestPort 4500 AllowHosts ' ' DenyHosts ' '
signal-event portforwarding-update

yum $AUTO install gcc $DEBUG
cd /opt
wget http://www.softether-download.com/files/softether/v4.25-9656-rtm-2018.01.15-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.25-9656-rtm-2018.01.15-linux-x64-64bit.tar.gz
tar zxvf softether-vpnserver-v4.25-9656-rtm-2018.01.15-linux-x64-64bit.tar.gz
cd vpnserver
# skip te displaying licence 
sed -i 's|default:|#|' /opt/vpnserver/Makefile
sed -i 's|@./.install.sh*|#|' /opt/vpnserver/Makefile
make
rm -f .install.sh
rm -f Auth*
rm -r ReadMe*
./vpnserver start
sleep 3
./vpnserver stop
# Starting and stopping vpnserver creates the initial config file automatically. After stopping we can adjust it.
# sed command to disable port 433 (already in use by server-manager)in config file.
sed -i '0,/bool Enabled/ s/true/false/' /opt/vpnserver/vpn_server.config
yum $AUTO remove gcc cloog-ppl cpp libgomp mpfr ppl $DEBUG

cat <<HERE2 > /etc/rc.d/init.d/vpnserver
#!/bin/sh
#
### BEGIN INIT INFO
# Provides: vpnserver
# Default-Start:
# Default-Stop:
# Should-Start: portreserve
# Required-Start: $network
# Required-Stop:
# Short-Description: Start and stop the vpnserver server
# Description: SoftEther VPN Server.
### END INIT INFO
DAEMON=/opt/vpnserver/vpnserver
LOCK=/var/lock/subsys/vpnserver
test -x \$DAEMON || exit 0
case "\$1" in
start)
\$DAEMON start
touch \$LOCK
;;
stop)
\$DAEMON stop
rm \$LOCK
;;
restart)
\$DAEMON stop
sleep 3
\$DAEMON start
;;
*)
echo "Usage: \$0 {start|stop|restart}"
exit 1
esac
exit 0
HERE2

chmod 755 /etc/rc.d/init.d/vpnserver
ln -s /etc/rc.d/init.d/vpnserver /etc/rc7.d/S79vpnserver
mkdir -p /etc/e-smith/templates-custom/etc/raddb/clients.conf
cat <<HERE3 > /etc/e-smith/templates-custom/etc/raddb/clients.conf/10localhost
{
 use esmith::util;
 \$pw = esmith::util::LdapPassword;
 \$pw =~ s/^(.{9}).*\$/\$1/;
 "";
}
client localhost \{
{
}	secret = { \$pw }
{
}	shortname = localhost
{
}	nastype = other
{
}\}
HERE3

mkdir -p /etc/e-smith/templates-custom/etc/radiusclient-ng/servers
cat <<HERE4 > /etc/e-smith/templates-custom/etc/radiusclient-ng/servers/10localhost
{
 use esmith::util;
 \$pw = esmith::util::LdapPassword;
 \$pw =~ s/^(.{9}).*\$/\$1/;
 "";
}
localhost { \$pw; }
HERE4

mkdir -p /etc/e-smith/templates-custom/etc/raddb/users/
cat <<HERE5 > /etc/e-smith/templates-custom/etc/raddb/users/40ldap
DEFAULT Auth-Type := LDAP
HERE5

/etc/rc.d/init.d/vpnserver start

echo Updating firewall rules, please wait...
signal-event remoteaccess-update
echo Radius shared key:
echo
cat /etc/radiusclient-ng/servers
