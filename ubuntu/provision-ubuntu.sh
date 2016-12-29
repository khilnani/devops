#!/bin/bash -x

echo '## Update'
apt-get -y update

echo '## Install packages'
apt-get -y install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties
apt-get -y install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev git-core
apt-get -y install software-properties-common python-software-properties python g++ make man mercurial meld curl
apt-get -y install ubuntu-desktop

echo '## Setup python'
apt-get -y install python-dev
apt-get -y install python-setuptools
easy_install pip
easy_install virtualenv

echo '## Kernal header files for VirtualBox'
sudo apt-get install linux-headers-$(uname -r)

echo '## Virtual Box Guest Additions'
sudo mount /dev/cdrom /mnt
cd /mnt
sudo ./VBoxLinuxAdditions.run

echo '## Install Ruby'
curl -L https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc
rvm install 2.3
rvm use 2.3 --default
ruby -v
echo "gem: --no-ri --no-rdoc" > ~/.gemrc

echo '## Install Rails'
gem install rails
rbenv rehash
rails -v

echo '## Install NodeJS'
add-apt-repository -y ppa:chris-lea/node.js
apt-get -y update
apt-get -y install nodejs

echo '## Install Chrome'
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - 
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
apt-get -y update 
apt-get -y install google-chrome-stable

echo '## Install Firefox'
sudo apt-get install firefox

echo '## Cucumber'
gem install cucumber

echo '## Selenium headless'
sudo apt-get install xvfb
mkdir /usr/lib/selenium
cd /usr/lib/selenium
wget http://selenium-release.storage.googleapis.com/2.43/selenium-server-standalone-2.43.1.jar
ln -s selenium-server-standalone-2.43.1.jar selenium-server-standalone.jar
mkdir -p /var/log/selenium
chmod a+w /var/log/selenium


