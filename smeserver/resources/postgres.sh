#!/bin/sh

# Copyright H.F. Wang - hsingfoo@gmail.com

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

#send a message
verbose "Installing and configuring PostgreSQL $database_version"

#Install and configure PostgreSQL
if [ $database_version = "9.4" ]; then
	service_name=postgresql-9.4 ; version=94 ; dbbin_name=postgresql94
else
	service_name=postgresql-9.6 ; version=96 ; dbbin_name=postgresql96
fi
yum $AUTO install $dbbin_name-server $dbbin_name-contrib $dbbin_name luapgsql --enablerepo=$dbbin_name
if [ $database_version = "9.4" ]; then
	mkdir -p /var/run/postgresql; chown postgres:postgres /var/run/postgresql
fi
export PGHOST="/var/run/postgresql"
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S64$service_name
config set $service_name service 
config setprop $service_name status enabled
config setprop $service_name TCPPort 5432
config setprop $service_name UDPPort 5432
config setprop $service_name access private
signal-event remoteaccess-update

# Initialize PostgreSQL database
/etc/rc.d/init.d/$service_name initdb
verbose "Postgresql version: $database_version"

verbose "Setting ident authentication to trust during installation"
# Adjust /var/lib/pgsql/9.4/data/pg_hba.conf to md5 and trust
sed -i 's/\(host  *all  *all  *127.0.0.1\/32  *\)ident/\1trust/' /var/lib/pgsql/$database_version/data/pg_hba.conf
sed -i 's/\(host  *all  *all  *::1\/128  *\)ident/\1trust/' /var/lib/pgsql/$database_version/data/pg_hba.conf


# set the path for the lock file
verbose "Setting socket location, watch it, it defaults to /tmp. Need to find out why!!!"
#sed -i  /var/lib/pgsql/$database_version/data/postgresql.conf -e s:"'/tmp':'/var/run/postgresql':"
#sed -i  /var/lib/pgsql/$database_version/data/postgresql.conf -e s:"#unix_socket_directories:unix_socket_directories:"
sed -i  /var/lib/pgsql/$database_version/data/postgresql.conf -e s:"#port = 5432:port = 5432:"

# Set environment variables
export PATH=$PATH:/usr/pgsql-$database_version/bin/
export LD_LIBRARY_PATH=/usr/pgsql-$database_version/lib/
export PGHOST=localhost

#Add user postgres to the www group
usermod -a -G www postgres

# Start Postgresql
/etc/rc.d/init.d/$service_name start

# Move to /tmp to prevent a red herring error when running sudo with psql
cwd=$(pwd)
cd /tmp
sudo -u postgres psql -c "CREATE DATABASE fusionpbx";
sudo -u postgres psql -c "CREATE DATABASE freeswitch";
sudo -u postgres psql -c "CREATE ROLE fusionpbx WITH SUPERUSER LOGIN PASSWORD '$database_password';"
sudo -u postgres psql -c "CREATE ROLE freeswitch WITH SUPERUSER LOGIN PASSWORD '$database_password';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE fusionpbx to fusionpbx;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE freeswitch to fusionpbx;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE freeswitch to freeswitch;"
