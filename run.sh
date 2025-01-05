#!/bin/bash

# Script to install FreePBX 17 on Ubuntu

# Update and Upgrade Ubuntu
sudo apt-get update && sudo apt-get upgrade -y

# Install Apache2
sudo apt-get install -y apache2

# Enable Apache2 rewrite module
sudo a2enmod rewrite

# Install MariaDB
sudo apt-get install -y mariadb-server

# Secure MariaDB
sudo mysql_secure_installation

# Install PHP and required modules
sudo apt-get install -y php php-cli php-common php-curl php-mbstring php-mysql php-xml php-json

# Restart Apache to load new config
sudo systemctl restart apache2

# Set up the database for FreePBX
sudo mysql -u root -p -e "CREATE DATABASE asterisk;"
sudo mysql -u root -p -e "CREATE USER 'asteriskuser'@'localhost' IDENTIFIED BY 'YOURPASSWORD';"
sudo mysql -u root -p -e "GRANT ALL PRIVILEGES ON asterisk.* TO 'asteriskuser'@'localhost';"
sudo mysql -u root -p -e "FLUSH PRIVILEGES;"

# Download FreePBX
cd /usr/src
sudo wget http://mirror.freepbx.org/modules/packages/freepbx/freepbx-17.0-latest.tgz
sudo tar xfz freepbx-17.0-latest.tgz

# Install FreePBX
cd freepbx
sudo ./start_asterisk start
sudo ./install -n

# Restart Apache to complete installation
sudo systemctl restart apache2

echo "FreePBX 17 installation complete."
