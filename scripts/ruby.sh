#!/bin/bash -x

export RVM_VERSION=2.4.1

echo '## Install Ruby'
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

# curl -sSL https://get.rvm.io | bash -s stable
curl -L https://get.rvm.io | bash -s stable 
rvm install $RVM_VERSION
rvm use $RVM_VERSION --default
ruby -v
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
