#!/bin/bash

# Check installed docker package
sudo dpkg -l | grep -i docker

# Completly remove docker
sudo apt-get purge -y docker-buildx-plugin docker-ce docker-ce-cli docker-ce-rootless-extras docker-compose-plugin
sudo apt-get autoremove -y --purge docker-buildx-plugin docker-ce docker-ce-cli docker-ce-rootless-extras docker-compose-plugin
sudo rm -rf /var/lib/docker /etc/docker
sudo rm /etc/apparmor.d/docker
sudo groupdel docker
sudo rm -rf /var/run/docker.sock
sudo rm -rf ~/.docker
sudo rm -rf /etc/docker
sudo rm -rf /var/lib/containerd

# Install docker
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker ${USER}
sudo chown root:docker /var/run/docker.sock
sudo apt install docker-compose