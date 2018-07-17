#!/bin/bash -x

echo '## Update'
apt-get -y update

echo '## Install packages'
apt-get -y install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties
apt-get -y install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev git-core
apt-get -y install software-properties-common python-software-properties python g++ make man mercurial meld curl

echo '## Setup python'
apt-get -y install python-dev
apt-get -y install python-setuptools
easy_install pip
easy_install virtualenv

pip install awscli --upgrade
pip install botocore boto3 --upgrade
pip install google-cloud-texttospeech --upgrade
pip install requests==2.6.0
pip install nltk --upgrade
pip install newspaper --upgrade
pip install numpy --upgrade
pip install sumy --upgrade

echo '## Setup Node'
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install 8.10.0
npm install -g serverless

#curl -O https://repo.anaconda.com/archive/Anaconda2-5.2.0-Linux-x86_64.sh
#bash Anaconda3-5.2.0-Linux-x86_64.sh

