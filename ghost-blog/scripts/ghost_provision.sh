#!/bin/bash

# Install Ghost blog on a new Ubuntu 18 LTS instance

# PREREQUISITES -- The Ghost blog user account, Nginx install, MySQL install, and NodeJS 12 LTS install

sudo adduser ghostblog
sudo usermod -aG sudo ghostblog
su - ghostblog

# Update system
sudo apt-get update
sudo apt-get upgrade

# Reboot
sudo reboot

# Log back in and assume the ghostblog user
su - ghostblog

# Install Nginx
sudo apt-get install -y nginx
sudo ufw allow 'Nginx Full'

# install mysql server and configure user
sudo apt-get install -y mysql-server
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Jello123';
quit

# install NodeJS 12
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash
sudo apt-get install -y nodejs

# INSTALL GHOST-CLI

sudo npm install ghost-cli@latest -g

# INSTALL GHOST BLOG

sudo mkdir -p /var/www/ghost
sudo chown -R ghostblog:ghostblog /var/www/ghost
sudo chmod 775 /var/www/ghost

cd /var/www/ghost
ghost install

# At the interactive prompt for configuration, do this:

- Enter your blog URL: --- use the IP address for now until DNS has been changed over. so "http://34.230.191.222" is appropriate.
- Enter your MySQL hostname --- use the default option. MySQL is on localhost.