#!/bin/bash

currentPHPver=$(php --version | head -n 1 | cut -d " " -f 2 | cut -c 1,2,3);

echo "Current PHP version is $currentPHPver"

echo -e "Specify the version to which you want to switch [Example:'7.1']"
read  phpversion

### Check inputs
if [ "$phpversion" = "" ]
then
    iserror="yes"
    hosterror="Specify the version to which you want to switch [Example:'7.1']"
fi

### Displaying errors
if [ "$iserror" = "yes" ]
then
    echo "Please correct following errors:"
    if [ "$hosterror" != "" ]
    then
        echo "$hosterror"
    fi
    exit;
fi


sudo a2dismod php$currentPHPver
sudo a2enmod php$phpversion
sudo service apache2 restart
sudo update-alternatives --set php /usr/bin/php$phpversion

php -v

