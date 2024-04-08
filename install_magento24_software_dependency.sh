#!/bin/bash

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

# Update system packages
apt update
apt upgrade -y

# Install Nginx
apt install nginx -y

# Install PHP 8.1 and required extensions
apt install software-properties-common -y
add-apt-repository ppa:ondrej/php -y
apt update
apt install php8.1 php8.1-fpm php8.1-cli php8.1-mysql php8.1-opcache php8.1-mbstring php8.1-xml php8.1-gd php8.1-curl php8.1-zip php8.1-intl php8.1-common php8.1-bcmath php8.1-soap php8.1-bz2 php8.1-calendar php8.1-ldap php8.1-imagick php8.1-redis -y

# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"

# Install Elasticsearch 7
# sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic-archive-keyring.gpg
# sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic-7.x.list'
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list'
sudo apt update
sudo apt install elasticsearch -y


# remove Elasticsearch 7
# apt purge elasticsearch -y
# sudo rm /etc/apt/sources.list.d/elastic-7.x.list

# Install Elasticsearch 8
# sudo apt install curl wget apt-transport-https default-jdk gnupg -y
# wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
# echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
# sudo apt update
# sudo apt install elasticsearch -y
# sudo systemctl enable elasticsearch.service --now
# cd /usr/share/elasticsearch/bin
# sudo ./elasticsearch-setup-passwords interactive
# sudo systemctl daemon-reload
# curl -uelastic -X GET 'http://localhost:9200'

# remove Elasticsearch 8
# apt purge elasticsearch -y
# sudo rm /etc/apt/sources.list.d/elastic-8.x.list


# Install MariaDB
apt install mariadb-server -y

# Install Redis
apt install redis-server -y

# Install RabbitMQ
apt install rabbitmq-server -y

# Enable and start services
systemctl enable nginx
systemctl enable php8.1-fpm
systemctl enable elasticsearch
systemctl enable mysql
systemctl enable redis-server
systemctl enable rabbitmq-server

systemctl start nginx
systemctl start php8.1-fpm
systemctl start elasticsearch
systemctl start mysql
systemctl start redis-server
systemctl start rabbitmq-server

# Output status
echo "Nginx, PHP, Composer, Elasticsearch, MariaDB, Redis, and RabbitMQ installed and started."
