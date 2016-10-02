#!/bin/bash -x

############################################
CWD=`pwd`
cd /tmp/
############################################


sudo apt-get install -y python-software-properties debconf-utils
sudo apt-add-repository -y ppa:webupd8team/java
sudo apt-get update -y
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer

############################################
cd $CWD
############################################
