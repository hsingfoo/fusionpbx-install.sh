#!/bin/bash

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

#
verbose "Adding unoffcial calmav signatures"
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
verbose "Configuring Heuristic scanning"
config setprop clamav HeuristicScanPrecedence yes
expand-template /etc/clamd.conf
sv t clamd

#
verbose "Configuring Bayesian Autolearning"
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
