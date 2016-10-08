#!/bin/sh -x

# use config.ssh.private_key_path in VagrantFile is using custom
# This downloads and installs the insecure vagrant public key

mkdir ~/.ssh

curl -o ~/.ssh/authorized_keys https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub

chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
