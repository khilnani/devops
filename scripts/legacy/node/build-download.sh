#!/bin/sh -x

VER=0.10.22

curl -O http://nodejs.org/dist/v$VER/node-v$VER.tar.gz
tar zxf node-v$VER.tar.gz

cd node-v$VER

pwd

./configure
make
make install

