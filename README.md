fusionpbx-install.sh for SME Server 9. A WIP !!! Not functional yet.
--------------------------------------
!!! This is a modified version for usage with Koozali SME Server 9.x !!! This script will NOT work on any other distribution !!! Please see https://contribs.org

This install script that has been designed to be an fast, simple, and modular way to to install FusionPBX on Koozali SME Server 9.x. 64 Bit *ONLY*

It installs:
* Koozali SME Server 9.x specific adjustements and custom templates
* smeserver-php-scl contrib
* smesever-webapps-common contrib
* FusionPBX 4.2.x stable
* FreeSWITCH 1.6.x and its dependencies
* PostgresQL 9.4.x
* PHP FPM
* haveged
* memcached

It uses the following repositories:
* EPEL
* REMI
* FWS
* centos-sclo-rh
* postgresql94
* nodejs
* irontec
* okay
* forensics

The repository definitations are embedded in the script.

At the end of the install it will instruct you to go to the ip address of the server in your web browser to finish the install. It will also provide a random database password for you to use during the web based phase of the install. The install script builds the fusionpbx database so you will not need to use the create database username and password on the last page of the web based install.

After you have completed the install you can login with the username and password you chose during the install. After you login go to them menu then Advanced -> Upgrade select the checkbox for App defaults.

Then go to Status -> SIP Status and start the SIP profiles, after this, go to Advanced -> Modules and find the module Memcached and click start.

How to use:
wget https://raw.githubusercontent.com/hsingfoo/fusionpbx-install.sh/master/install.sh -O install.sh && sh install.sh