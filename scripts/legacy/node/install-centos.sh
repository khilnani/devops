#!/bin/sh -x

FILE=epel-release-6-8.noarch.rpm

curl -O http://download-i2.fedoraproject.org/pub/epel/6/i386/$FILE

sudo rpm -ivh $FILE

sudo yum -y install npm --enablerepo=epel

rm -rf $FILE
