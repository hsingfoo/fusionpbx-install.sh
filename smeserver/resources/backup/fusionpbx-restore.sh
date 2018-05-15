#!/bin/sh

now=$(date +%Y-%m-%d)

remote_server=162.208.16.3

#delete freeswitch logs older 7 days
find /usr/local/freeswitch/log/freeswitch.log.* -mtime +7 -exec rm {} \;

#message to the console
echo "Restoring the Backup"

#extract the backup from the tgz file
tar -xvpzf /var/backups/fusionpbx/backup_$now.tgz -C /

#remove the old database
psql --host=127.0.0.1 --username=fusionpbx -c 'drop schema public cascade;'
psql --host=127.0.0.1 --username=fusionpbx -c 'create schema public;'

#restore the database
pg_restore -Fc --host=127.0.0.1 --dbname=fusionpbx --username=fusionpbx /var/backups/fusionpbx/postgresql/fusionpbx_pgsql_$now.sql
echo "Restore Complete";
