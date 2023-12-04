#!/bin/bash

function switch_php() {
  if [ "$1" == "7.3" ]; then
    sudo update-alternatives --set php /usr/bin/php7.3
  elif [ "$1" == "8.1" ]; then
    sudo update-alternatives --set php /usr/bin/php8.1
  else
    echo "Invalid PHP version. Supported versions: 7.3, 8.1"
  fi
}

function switch_composer() {
  if [ "$1" == "1" ]; then
    sudo composer self-update --1
  elif [ "$1" == "2" ]; then
    sudo composer self-update --2
  else
    echo "Invalid Composer version. Supported versions: 1, 2"
  fi
}

function switch_apache() {
  if [ "$1" == "7.3" ]; then
    sudo a2dismod php8.1
    sudo a2enmod php7.3
    sudo systemctl restart apache2
  elif [ "$1" == "8.1" ]; then
    sudo a2dismod php7.3
    sudo a2enmod php8.1
    sudo systemctl restart apache2
  else
    echo "Invalid PHP version. Supported versions: 7.3, 8.1"
  fi
}

if [ "$1" == "php" ]; then
  switch_php "$2"
elif [ "$1" == "composer" ]; then
  switch_composer "$2"
elif [ "$1" == "apache" ]; then
  switch_apache "$2"
else
  echo "Usage: $0 [php|composer|apache] [7.3|8.1|1|2]"
fi

