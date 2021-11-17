#!/bin/bash

echo -e "Please provide hostname. e.g.dev,staging"
read  hostname

### Check inputs
if [ "$hostname" = "" ]
then
    iserror="yes"
    hosterror="Please provide domain name."
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

sudo a2dissite $hostname".conf"
sudo systemctrl reload apache2.service
sudo rm /etc/apache2/sites-available/$hostname".conf"
sudo rm -r /var/www/$hostname

mysqlvar=$(echo $hostname | cut -d'.' -f 1)
echo "Enter mySQL root password if you want drop database $mysqlvar"
sudo mysql -uroot -p <<EOF
DROP DATABASE $mysqlvar;
EOF
