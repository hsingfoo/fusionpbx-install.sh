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


