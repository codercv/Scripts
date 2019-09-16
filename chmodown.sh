#!/bin/bash

echo 'chown codercv:www-data '$1
sudo chown -R codercv:www-data $1
echo 'chmod directories 775'
sudo find $1/. -type d -exec chmod 775 {} \;
echo 'chmod files 664'
sudo find $1/. -type f -exec chmod 664 {} \;
echo "chown/chmod - DONE"

