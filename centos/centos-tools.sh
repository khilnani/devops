#!/bin/sh -x

##############################################
#
##############################################

yum -y groupinstall "Development Tools"
yum -y install man
yum -y install ruby
yum -y install wget
yum -y install curl
yum -y install git-core
yum -y install links lynx

yum -y install gcc g++ make automake autoconf curl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel

yum -y install ruby-rdoc ruby-devel

yum -y install rubygems
gem update
gem update --system

yum -y install python-setuptools
easy_install pip

##############################################
