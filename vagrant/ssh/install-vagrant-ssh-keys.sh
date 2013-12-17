#!/bin/sh -x

curl -o ~/.ssh/id_rsa https://raw.github.com/mitchellh/vagrant/master/keys/vagrant
curl -o ~/.ssh/id_rsa.pub https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub

chmod 600 ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa.pub
