#!/bin/bash -x


echo '## Install Ruby'
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -L https://get.rvm.io | bash -s stable
rvm install $RVM_VERSION
rvm use $RVM_VERSION --default
ruby -v
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
