#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

# Set system services and settings
echo Changing some system settings
service smolt stop
config setprop smolt status disabled
service smb stop
config setprop smb status disabled
config setprop sshd AutoBlock disabled
signal-event remoteaccess-update

#
echo Adding unoffcial calmav signatures
yum $AUTO install smeserver-clamav-unofficial-sigs --enablerepo=fws,epel
config setprop clamd MemLimit 1500000000

#
echo Removing securiteinfo databases from conf file
config delprop clamav-unofficial-sigs securiteinfo.hdb securiteinfobat.hdb \
securiteinfodos.hdb securiteinfoelf.hdb securiteinfohtml.hdb securiteinfooffice.hdb \
securiteinfopdf.hdb securiteinfosh.hdb honeynet.hdb mbl.ndb
signal-event clamav-update
clamav-unofficial-sigs.sh

# 
echo Enabling Heuristic scanning
config setprop clamav HeuristicScanPrecedence yes
expand-template /etc/clamd.conf
sv t clamd

#
echo Enable Bayesian Autolearning
config setprop spamassassin UseBayes 1
config setprop spamassassin BayesAutoLearnThresholdSpam 6.00
config setprop spamassassin BayesAutoLearnThresholdNonspam 0.10
expand-template /etc/mail/spamassassin/local.cf
sa-learn --sync --dbpath /var/spool/spamd/.spamassassin -u spamd
chown spamd.spamd /var/spool/spamd/.spamassassin/bayes_*
chown spamd.spamd /var/spool/spamd/.spamassassin/bayes.mutex
chmod 640 /var/spool/spamd/.spamassassin/bayes_* 
config setprop spamassassin status enabled
config setprop spamassassin RejectLevel 12
config setprop spamassassin TagLevel 4
config setprop spamassassin Sensitivity custom
signal-event email-update

#
echo creating custom template for HSTS
mkdir -p /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf/VirtualHosts/
cat <<HERE1 > /etc/e-smith/templates-custom/etc/httpd/conf/httpd.conf/VirtualHosts/04StrictTransportSecurity
### Enable HTTP Strict Transport Security, lifetime 6 months  ###
Header always add Strict-Transport-Security "max-age=15768000; includeSubDomains; preload" env=HTTPS
HERE1
expand-template /etc/httpd/conf/httpd.conf
service httpd-e-smith restart

#
echo Installing user-panel and user-panels, vacation, remoteuseraccess, wordpress, dehydrated and check4updates
yum $AUTO install smeserver-userpanel smeserver-userpanels smeserver-vacation smeserver-remoteuseraccess smeserver-wordpress dehydrated smeserver-check4updates --enablerepo=smecontribs,fws,epel
signal-event wordpress-update

#
echo Installing Dokuwiki
yum $AUTO install --enablerepo=fws smeserver-dokuwiki dokuwiki-plugins
signal-event webapps-update

#
echo Installing fail2ban
yum $AUTO --enablerepo=fws --enablerepo=epel install smeserver-fail2ban
db configuration setprop masq status enabled
expand-template /etc/rc.d/init.d/masq
/etc/init.d/masq restart
signal-event fail2ban-conf
# Manually create check_ban script from wiki page

#
echo Installing Redis
yum $AUTO --enablerepo=epel install redis
config set redis service status enabled
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S80redis
usermod -a -G redis www
sed -i 's|# unixsocket.*|unixsocket /var/run/redis/redis.sock|' /etc/redis.conf
sed -i 's/# unixsocketperm.*/unixsocketperm 777/' /etc/redis.conf
/etc/rc.d/init.d/redis start

#
echo Install Softether VPN
db portforward_tcp set 1194 forward Comment 'SoftEther OpenVPN' DestHost localhost DestPort 1194 AllowHosts ' ' DenyHosts ' '
db portforward_tcp set 5555 forward Comment 'SoftEther Management' DestHost localhost DestPort 5555 AllowHosts ' ' DenyHosts ' '
db portforward_udp set 1194 forward Comment 'SoftEther OpenVPN' DestHost localhost DestPort 1194 AllowHosts ' ' DenyHosts ' '
db portforward_udp set 500 forward Comment 'SoftEther SoftEther L2TP/IPSec' DestHost localhost DestPort 500 AllowHosts ' ' DenyHosts ' '
db portforward_udp set 1701 forward Comment 'SoftEther SoftEther L2TP/IPSec' DestHost localhost DestPort 1701 AllowHosts ' ' DenyHosts ' '
db portforward_udp set 4500 forward Comment 'SoftEther SoftEther L2TP/IPSec' DestHost localhost DestPort 4500 AllowHosts ' ' DenyHosts ' '
signal-event portforwarding-update

yum $AUTO install gcc
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
yum $AUTO remove gcc cloog-ppl cpp libgomp mpfr ppl

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

#Install memcached
echo ""
verbose "Installing and configuring memached"
yum $AUTO install memcached
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S90memcached
config set memcached service status enabled

#Install haveged"
echo ""
verbose "Installing and configuring haveged"
yum $AUTO install haveged --enablerepo=epel
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S90haveged
config set haveged service status enabled

#Install git and sngrep
echo ""
verbose "Installing and configuring sngrep"
yum $AUTO install sngrep --enablerepo=irontec

#Install SharedFolders
yum $AUTO--enablerepo=smecontribs install smeserver-shared-folders
yum $AUTO --enablerepo=smecontribs --enablerepo=epel install fuse-encfs

#Restart Apache
expand-template /etc/httpd/conf/httpd.conf
service httpd-e-smith restart
