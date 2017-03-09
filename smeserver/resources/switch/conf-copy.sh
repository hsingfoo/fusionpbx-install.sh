mv /etc/freeswitch /etc/freeswitch.orig
mkdir /etc/freeswitch
cp -R $www_path/resources/templates/conf/* /etc/freeswitch
