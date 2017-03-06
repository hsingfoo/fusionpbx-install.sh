#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

. ./colors.sh

#send a message
verbose "Installing PostgreSQL 9.4"

#generate a random password
password=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64)

#Install and configure PostgreSQL 9.4
echo Installing PostgreSQL 9.4
yum -y install postgresql94-server postgresql94-contrib postgresql94 --enablerepo=postgresql94
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S64postgresql-9.4
config set postgresql-9.4 service 
config setprop postgresql-9.4 status enabled
config setprop postgresql-9.4 TCPPort 5432
config setprop postgresql-9.4 UDPPort 5432
config setprop postgresql-9.4 access private
signal-event remoteaccess-update

# Initialize PostgreSQL database
echo “Initialize PostgreSQL database”
/etc/rc.d/init.d/postgresql-9.4 initdb

# Adjust /var/lib/pgsql/9.4/data/pg_hba.conf to MD5 local users
sed -i 's/\(host  *all  *all  *127.0.0.1\/32  *\)ident/\1md5/' /var/lib/pgsql/9.4/data/pg_hba.conf
sed -i 's/\(host  *all  *all  *::1\/128  *\)ident/\1md5/' /var/lib/pgsql/9.4/data/pg_hba.conf

# Start Postgresql
/etc/rc.d/init.d/postgresql-9.4 start

# Move to /tmp to prevent a red herring error when running sudo with psql
cwd=$(pwd)
cd /tmp
sudo -u postgres psql -c "DROP SCHEMA public cascade;";
sudo -u postgres psql -c "CREATE SCHEMA public;";
sudo -u postgres psql -c "CREATE DATABASE fusionpbx";
sudo -u postgres psql -c "CREATE DATABASE freeswitch";
sudo -u postgres psql -c "CREATE ROLE fusionpbx WITH SUPERUSER LOGIN PASSWORD 'supersecret';"
sudo -u postgres psql -c "CREATE ROLE freeswitch WITH SUPERUSER LOGIN PASSWORD 'supersecret';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE fusionpbx to fusionpbx;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE freeswitch to fusionpbx;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE freeswitch to freeswitch;"
cd $cwd

echo PostgreSQL 9.4 installed
