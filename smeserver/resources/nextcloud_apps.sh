# Copyright H.F. Wang - hsingfoo@gmail.com

# move to script directory so all relative paths work
cd "$(dirname "$0")"

# This script must be run when SCL PHP is active

#includes
. ./config.sh
. ./colors.sh
cd $cloud_path

php occ maintenance:install --database $cloud_dbtype --database-host $cloud_dbhost \
--database-name $cloud_dbname --database-user $cloud_dbusername --database-pass $cloud_dbpassword \
--admin-user $cloud_adminname --admin-pass $cloud_adminpass

# Adjust .htaccess and install and/or enable nextcloud apps
php occ app:install calendar
php occ app:enable calendar
php occ app:install files_downloadactivity
php occ app:enable files_downloadactivity
php occ app:install quota_warning
php occ app:enable quota_warning
php occ app:install ransomware_protection
php occ app:enable ransomware_protection
php occ app:install apporder
php occ app:enable apporder
php occ app:install themeing_customcss
php occ app:enable theming_customcss
php occ app:install groupfolders
php occ app:enable groupfolders
php occ app:install onlyoffice
php occ app:enable onlyoffice
php occ app:install files_pdfviewer
php occ app:enable files_pdfviewer
php occ app:install news
php occ app:enable news
php occ app:install previewgenerator
php occ app:enable previewgenerator
php occ app:install spreed
php occ app:enable spreed
php occ app:install mail
php occ app:enable mail
php occ app:install bruteforcesettings
php occ app:enable bruteforcesettings
php occ app:install passwords
php occ app:enable passwords
php occ app:install files_antivirus
php occ app:enable files_antivirus
php occ app:install quicknotes
php occ app:enable quicknotes
php occ app:install files_retention
php occ app:enable files_retention
php occ app:enable files_external
php occ app:enable admin_audit
php occ maintenance:mode --on
php occ maintenance:update:htaccess
php occ maintenance:mode --off
