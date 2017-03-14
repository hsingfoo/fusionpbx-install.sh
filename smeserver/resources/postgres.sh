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

#echo $version | sed 's/[.,]//g'

#Install and configure PostgreSQL
echo $database_version
if [ .$database_version = ."9.4" ]; then
	service_name=postgresql-9.4 ; version=94 ; dbbin_name=postgresql94
else
	service_name=postgresql-9.6 ; version=96 ; dbbin_name=postgresql96
fi
echo $service_name and $dbbin_name	
echo $dbbin_name-server
yum -y -q install $dbbin_name-server $dbbin_name-contrib $dbbin_name --enablerepo=$dbbin_name
ln -s /etc/rc.d/init.d/e-smith-service /etc/rc7.d/S64$service_name
config set $service_name service 
config setprop $service_name status enabled
config setprop $service_name TCPPort 5432
config setprop $service_name UDPPort 5432
config setprop $service_name access private
signal-event remoteaccess-update

# Initialize PostgreSQL database
/etc/rc.d/init.d/$service_name initdb

# Adjust /var/lib/pgsql/9.4/data/pg_hba.conf to MD5 local users
#sed -i 's/\(local  *all  *all    *\)peer/\1md5/' /var/lib/pgsql/9.4/data/pg_hba.conf
sed -i 's/\(host  *all  *all  *127.0.0.1\/32  *\)ident/\1trust/' /var/lib/pgsql/$database_verion/data/pg_hba.conf
sed -i 's/\(host  *all  *all  *::1\/128  *\)ident/\1trust/' /var/lib/pgsql/$database_version/data/pg_hba.conf

#Add user postgres to the www group
# usermod -a -G www postgres

# Start Postgresql
/etc/rc.d/init.d/$service_name start

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
