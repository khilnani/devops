#!/bin/bash -x

#  https://docs.continuum.io/anaconda/install

echo '## Install Anaconda'
curl -O https://repo.anaconda.com/archive/Anaconda3-$ANACONDA_VERSION-Linux-x86_64.sh
bash Anaconda3-$ANACONDA_VERSION-Linux-x86_64.sh -b -p $ANACONDA_HOME

conda config --add channels conda-forge
conda install --yes m2-base
