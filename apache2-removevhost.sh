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

a2dissite $hostname".conf"
/etc/init.d/apache2 reload
rm /etc/apache2/sites-available/$hostname".conf"
rm -r /var/www/$hostname

mysqlvar=$(echo $hostname | cut -d'.' -f 1)
echo "Enter mySQL root password if you want drop database $mysqlvar"
mysql -uroot -p <<EOF
DROP DATABASE $mysqlvar;
EOF
