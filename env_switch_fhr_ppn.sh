#!/bin/bash

echo "Select environment:"
echo "1. fhr => ppn"
echo "2. ppn => fhr"

read -p "Enter your choice (1 or 2): " choice

case $choice in
  1)
    # fhr => ppn env switch
    echo "fhr => ppn env switch"
    sudo systemctl stop apache2.service
    sudo systemctl stop mariadb.service
    docker start $(docker ps -q)
    sudo composer self-update --2
    sudo a2dismod php7.3
    sudo a2enmod php8.1
    sudo service apache2 restart
    sudo update-alternatives --set php /usr/bin/php8.1
    ;;
  2)
    # ppn => fhr env switch
    echo "ppn => fhr env switch"
    docker stop $(docker ps -a -q)
    sudo systemctl start apache2.service
    sudo systemctl start mariadb.service
    sudo composer self-update --1
    sudo a2dismod php8.1
    sudo a2enmod php7.3
    sudo service apache2 restart
    sudo update-alternatives --set php /usr/bin/php7.3
    ;;
  *)
    echo "Invalid choice. Please enter 1 or 2."
    ;;
esac
