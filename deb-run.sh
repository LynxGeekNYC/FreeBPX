#!/bin/bash

# Script to install Asterisk 22.1 and FreePBX 17 on Debian

# Update and Upgrade Debian
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

# Install additional dependencies for Asterisk
sudo apt-get install -y build-essential wget subversion
sudo apt-get install -y libncurses-dev libssl-dev libxml2-dev libsqlite3-dev uuid-dev

# Install Asterisk
cd /usr/src
sudo wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-22-current.tar.gz
sudo tar xvf asterisk-22-current.tar.gz
cd asterisk-22.*/
sudo contrib/scripts/get_mp3_source.sh
sudo contrib/scripts/install_prereq install
sudo ./configure
sudo make menuselect
sudo make
sudo make install
sudo make samples
sudo make config
sudo ldconfig
sudo systemctl restart asterisk

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

echo "Asterisk 22.1 and FreePBX 17 installation complete."
