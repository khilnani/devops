#!/usr/bin/env sh -x

echo '## Update'
apt-get -y update

echo '## Install git'
apt-get -y install git-core

## Install Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - 
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
apt-get -y update 
apt-get -y install google-chrome-stable

echo '## Install mongo db'
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
apt-get -y update
apt-get -y install mongodb-org
mkdir /data
mkdir /data/db

echo '## Install LAMP'
apt-get -y install tasksel
tasksel install lamp-server

echo '## Download Adminer'
wget http://www.adminer.org/latest-en.php -O /var/www/html/adminer.php
chmod 755 /var/www/html/adminer.php

echo '## /etc/rc.local'
echo '/etc/init.d/apache2 start' > /etc/rc.local
echo '/usr/bin/mongod --smallfiles --fork --config /etc/mongod.conf' >> /etc/rc.local
echo 'export HOME=/etc/mysql' >> /etc/rc.local
echo 'umask 007' >> /etc/rc.local
echo '[ -d /var/run/mysqld ] || install -m 755 -o mysql -g root -d /var/run/mysqld' >> /etc/rc.local
echo '/usr/sbin/mysqld &' >> /etc/rc.local
