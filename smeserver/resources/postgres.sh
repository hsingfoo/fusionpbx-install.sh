#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

#send a message
echo ""
verbose "Installing and configuring PostgreSQL $database_version"

#generate a random password
#password=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64)
password=supersecret

#Install and configure PostgreSQL
if $database_version="94"; then
	version=9.4
else
	version=9.6
fi
	
yum -y -q install postgresql$database_version-server postgresql$database_version-contrib postgresql$database_version --enablerepo=postgresql$database-version
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S64postgresql-$version
config set postgresql-$version service 
config setprop postgresql-$version status enabled
config setprop postgresql-$version TCPPort 5432
config setprop postgresql-$version UDPPort 5432
config setprop postgresql-$version access private
signal-event remoteaccess-update

# Initialize PostgreSQL database
/etc/rc.d/init.d/postgresql-$version initdb

# Adjust /var/lib/pgsql/9.4/data/pg_hba.conf to MD5 local users
#sed -i 's/\(local  *all  *all    *\)peer/\1md5/' /var/lib/pgsql/9.4/data/pg_hba.conf
sed -i 's/\(host  *all  *all  *127.0.0.1\/32  *\)ident/\1md5/' /var/lib/pgsql/$version/data/pg_hba.conf
sed -i 's/\(host  *all  *all  *::1\/128  *\)ident/\1md5/' /var/lib/pgsql/$version/data/pg_hba.conf

#Add user postgres to the www group
# usermod -a -G www postgres

# Start Postgresql
/etc/rc.d/init.d/postgresql-$version start

# Move to /tmp to prevent a red herring error when running sudo with psql
cwd=$(pwd)
cd /tmp
#sudo -u postgres psql -d fusionpbx -c "DROP SCHEMA public cascade;";
#sudo -u postgres psql -d fusionpbx -c "CREATE SCHEMA public;";
sudo -u postgres psql -c "CREATE ROLE root WITH SUPERUSER LOGIN";
sudo -u postgres psql -c "CREATE DATABASE fusionpbx";
sudo -u postgres psql -c "CREATE DATABASE freeswitch";
sudo -u postgres psql -c "CREATE ROLE fusionpbx WITH SUPERUSER LOGIN PASSWORD '$password';"
sudo -u postgres psql -c "CREATE ROLE freeswitch WITH SUPERUSER LOGIN PASSWORD '$password';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE fusionpbx to fusionpbx;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE freeswitch to fusionpbx;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE freeswitch to freeswitch;"

cd $cwd
