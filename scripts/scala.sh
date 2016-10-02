#!/bin/bash -x

############################################
CWD=`pwd`
cd /tmp/
############################################

############################################
# Scala
############################################

wget http://www.scala-lang.org/files/archive/scala-$SCALA_VERSION.tgz
sudo mkdir $SCALA_INSTALL_DIR
sudo tar xvf scala-$SCALA_VERSION.tgz -C $SCALA_INSTALL_DIR

############################################
# sbt
############################################

echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list  
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823  
sudo apt-get update -y
sudo apt-get install -y sbt 


############################################
cd $CWD
############################################
