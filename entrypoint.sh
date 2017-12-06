#!/bin/bash

set -eo pipefail
shopt -s nullglob

# sendmail
echo "127.0.0.1 $(hostname).localdomain $(hostname)" >> /etc/hosts

# document root
echo "${APACHE_DOCUMENT_ROOT}"

if test "${APACHE_DOCUMENT_ROOT}" != ""; then
    sed -ri -e "s!/var/www/html!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/sites-available/*.conf
    sed -ri -e "s!/var/www/!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
fi

service sendmail restart
service apache2 restart

trap 'service apache2 stop; exit 0' TERM

while :
do
    sleep 1
done