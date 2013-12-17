#!/bin/sh -x

##############################################
# Install core software
##############################################

yum -y groupinstall "Development Tools"
yum -y install man ruby wget curl git-core 
yum -y install gcc g++ make automake autoconf curl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel
yum -y install ruby-rdoc ruby-devel
yum -y install rubygems
gem update
gem update --system
yum -y install python-setuptools
easy_install pip

##############################################
