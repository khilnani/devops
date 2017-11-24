#!/bin/sh

# apt-get -y install build-essential 
# https://github.com/creationix/nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash
source ~/.bashrc

nvm install 6.10
nvm use node 6.10
nvm alias default 6.10

node -v
