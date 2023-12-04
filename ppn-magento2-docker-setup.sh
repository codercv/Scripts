#!/bin/bash

# Check if Apache is running
if pgrep apache2 > /dev/null
then
    echo "Stopping Apache..."
    sudo service apache2 stop
    echo "Apache stopped."
else
    echo "Apache is not running."
fi

# Check if Nginx is running
if pgrep nginx > /dev/null
then
    echo "Stopping Nginx..."
    sudo service nginx stop
    echo "Nginx stopped."
else
    echo "Nginx is not running."
fi

#switch to php 8.1
desired_php_version="8.1"
current_php_version=$(php -v | head -n 1 | cut -d " " -f 2 | cut -d "." -f 1,2)
if [ "$current_php_version" != "$desired_php_version" ]; then
    echo "Switching PHP version to $desired_php_version"
    sudo update-alternatives --set php /usr/bin/php$desired_php_version
    #sudo a2dismod php$current_php_version
    #sudo a2enmod php$desired_php_version
    #sudo service apache2 restart
    echo "PHP version switched to $desired_php_version"
else
    echo "PHP version is already $desired_php_version"
fi

# Check if docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker CLI is not installed. Installing Docker..."

    # Install Docker
    sudo apt update
    sudo apt install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install docker-ce
    sudo usermod -aG docker ${USER}
    sudo chown root:docker /var/run/docker.sock
    sudo systemctl status docker

    echo "Docker CLI has been installed. Please log out and log back in to apply group changes."
else
    echo "Docker CLI is already installed."
fi

# Switch to composer 2
sudo composer self-update --2
# Stop local mariaDB
sudo systemctl stop mariadb.service

mkdir -p /var/www/ppn.local
cd /var/www/ppn.local
composer create-project --repository-url=https://repo.magento.com/  magento/project-community-edition &&
mv /var/www/ppn.local/project-community-edition/* /var/www/ppn.local
rm -rf /var/www/ppn.local/project-community-edition
composer require --no-update --dev magento/ece-tools magento/magento-cloud-docker
echo "name: magento
system:
    mode: 'production'
services:
    php:
        version: '8.1'
        extensions:
            enabled:
                - xsl
                - json
                - redis
    mysql:
        version: '10.6'
        image: 'mariadb'
    redis:
        version: '7.0'
        image: 'redis'
    elasticsearch:
        version: '7.10'
        image: 'magento/magento-cloud-docker-elasticsearch'
    mailhog:
        version: '1.0-1.4.0'
        image: 'magento/magento-cloud-docker-mailhog'
    rabbitmq:
        version: '3.11'
        image: rabbitmq
hooks:
    build: |
        set -e
        php ./vendor/bin/ece-tools run scenario/build/generate.xml
        php ./vendor/bin/ece-tools run scenario/build/transfer.xml
    deploy: 'php ./vendor/bin/ece-tools run scenario/deploy.xml'
    post_deploy: 'php ./vendor/bin/ece-tools run scenario/post-deploy.xml'
mounts:
    var:
        path: 'var'
    app-etc:
        path: 'app/etc'
    pub-media:
        path: 'pub/media'
    pub-static:
        path: 'pub/static'" > .magento.docker.yml
composer update
curl -sL https://github.com/magento/magento-cloud-docker/releases/download/1.3.5/init-docker.sh | bash -s -- --php 8.1
./vendor/bin/ece-docker build:compose --mode="developer"
# Remove all docker containers
#docker rm -f $(docker ps -aq)
docker-compose up -d
docker-compose run --rm deploy cloud-deploy
docker-compose run --rm deploy magento-command deploy:mode:set developer
docker-compose run --rm deploy cloud-post-deploy
docker-compose ps
echo "Site availible on:"
echo "http://localhost:80"
echo "https://localhost:443"
echo "Database:"
echo user: magento2
echo password: magento2
echo host: localhost
echo port: check docker container db_1 (example 0.0.0.0:32770->3306/tcp,:::32770->3306/tcp PORT FOR HOST PC IS = 32770)
