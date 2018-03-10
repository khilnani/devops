#!/bin/sh -x

sudo apt-get -y install git-core mosh

sudo mkdir /data
sudo mkdir /data/git

mkdir /home/ubuntu/.jupyter
sudo mkdir /root/.jupyter

# two factor - run: google-authenticator
sudo apt-get -y install libpam-google-authenticator
