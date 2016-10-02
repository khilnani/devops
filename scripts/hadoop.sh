#!/bin/bash -x

############################################
CWD=`pwd`
cd /tmp/
############################################

wget -O /tmp/hadoop-$HADOOP_VERSION.tar.gz http://mirror.cogentco.com/pub/apache/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
sudo tar -xvzf /tmp/hadoop-$HADOOP_VERSION.tar.gz -C $HADOOP_INSTALL_DIR


############################################
cd $CWD
############################################
