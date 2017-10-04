#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

mv /etc/freeswitch /etc/freeswitch.orig
mkdir /etc/freeswitch
cp -R $www_path/resources/templates/conf/* /etc/freeswitch
