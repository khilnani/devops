#!/bin/sh

yum install -y sqlite-devel
cd /opt
wget --no-check-certificate https://www.python.org/ftp/python/2.7.6/Python-2.7.6.tar.xz
tar xf Python-2.7.6.tar.xz
cd Python-2.7.6
./configure --prefix=/usr
make && make altinstall

cd /opt
wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
python2.7 ez_setup.py
easy_install-2.7 pip
pip2.7 install virtualenv
mkdir /opt/py27
virtualenv /opt/py27
