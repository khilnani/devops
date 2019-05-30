#!/bin/bash

# Get file encoding: file -i
pkg install -y file
# Change file encoding: iconv -f FROM_ENC -t TO_ENC IN_FILE
# iconv -f UTF-16BE -t US-ASCII//IGNORE js/utils.js > u.js
pkg install -y iconv
pkg install -y vim # vim-python
# Needed for openssl / SRI.sh
pkg install -y openssl-tool
# Misc tools
pkg install -y openssl-dev openssh rsync curl unzip zip dnsutils jq
# tput for javascript-obfuscator
pkg install -y ncurses-utils

pkg update

pkg install -y git
pkg install -y python-dev
pkg install -y python2
pkg install -y nodejs
pkg install -y php
pkg install -y ruby-dev clang make libffi-dev 
pkg install -y nginx

pkg update

pip install arrow requests
pip install awscli
pip install numpy pandas nltk scipy scikit-learn spacy newspaper
pip install matplotlib seaborn
pip install jupyter

npm install -g create-react-app jsonlint

echo 'alias vi="vim"' >> ~/.bashrc
source ~/.bashrc

rm -f /data/data/com.termux/files/usr/bin/vi

# curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

# export NVM_DIR="${XDG_CONFIG_HOME/:-$HOME/.}nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# nvm install 8.10
# nvm use 8.10
# nvm alias default 8.10
