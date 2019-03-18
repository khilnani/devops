#!/bin/sh

# apt-get -y install build-essential 
# https://github.com/creationix/nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
source ~/.bashrc

nvm install 8.10
nvm use node 8.10
nvm alias default 8.10

node -v
