#!/usr/bin/env bash

wget https://repo.anaconda.com/archive/Anaconda3-2018.12-Linux-x86_64.sh -O /tmp/Anaconda3-2018.12-Linux-x86_64.sh
bash /tmp/Anaconda3-2018.12-Linux-x86_64.sh -b -p /opt/anaconda3

echo 'source /opt/anaconda3/etc/profile.d/conda.sh' >> ~/.bashrc
echo 'source /opt/anaconda3/etc/profile.d/conda.sh' >> ~/.zshrcc

echo 'export PATH=/opt/anaconda3/bin:$PATH' >> ~/.bashrc
echo 'export PATH=/opt/anaconda3/bin:$PATH' >> ~/.zshrc

source /opt/anaconda3/etc/profile.d/conda.sh
export PATH=/opt/anaconda3/bin:$PATH

conda config --add channels conda-forge
conda update --all
