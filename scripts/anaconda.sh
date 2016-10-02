#!/bin/bash -x

#  https://docs.continuum.io/anaconda/install

echo '## Install Anaconda'
curl -O http://repo.continuum.io/archive/Anaconda2-$ANACONDA_VERSION-Linux-x86_64.sh
bash Anaconda2-$ANACONDA_VERSION-Linux-x86_64.sh -b -p $ANACONDA_HOME
