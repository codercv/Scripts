#!/bin/bash

read -r -p "Chose action for $1 in
[M/m] - chmod for all dirs to 775 and for files 664
[O/o] - chown $USER:www-data
[Y/y] - both chmod + chown
[N/n] - Cancel
" input
case $input in
    [yY])
echo "chown $USER:www-data "$1
sudo chown -R $USER:www-data $1
echo "chmod directories 775"
sudo find $1/. -type d -exec chmod 775 {} \;
echo "chmod files 664"
sudo find $1/. -type f -exec chmod 664 {} \;
echo "chown and chmod - DONE for $1"
 ;;
    [mM])
 echo "chmod directories 775"
 sudo find $1/. -type d -exec chmod 775 {} \;
 echo "chmod files 664"
 sudo find $1/. -type f -exec chmod 664 {} \;
 echo "chmod - DONE for $1"
 ;;
    [oO])
 echo "chown $USER:www-data "$1
 sudo chown -R $USER:www-data $1
 echo "chown - DONE for $1"
 ;;
    [nN])
 echo "Operation Canceled. Permissions and owners don't changed for $1"
 ;;
    *)
 echo "Invalid input..."
 ;;
esac
