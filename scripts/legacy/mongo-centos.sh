#!/usr/bin/env sh

# http://docs.mongodb.org/ecosystem/platforms/amazon-ec2/#deploy-mongodb-ec2

sudo yum -y update

echo "[MongoDB]
name=MongoDB Repository
baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64
gpgcheck=0
enabled=1" | sudo tee -a /etc/yum.repos.d/mongodb.repo

sudo yum install -y mongo-10gen-server

sudo chkconfig mongod on

sudo vi  /etc/mongod.conf
