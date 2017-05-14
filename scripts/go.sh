#!/bin/sh -x

export GOVERSION=1.8
echo "GOVERSION: $GOVERSION"
#export GOPATH=`pwd`
export GOPATH=$HOME/go-work
echo "GOPATH: $GOPATH"

curl -O https://storage.googleapis.com/golang/go$GOVERSION.linux-amd64.tar.gz
tar xvf go$GOVERSION.linux-amd64.tar.gz
mv go /usr/local

mkdir -p $GOPATH

echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
echo 'export GOPATH=$GOPATH' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> ~/.bashrc

source ~/.bashrc

go version
go env

go get golang.org/x/tour/gotour
echo "gotour Installed, run: gotour"
