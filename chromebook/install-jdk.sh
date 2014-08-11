#!/bin/sh

sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java7-installer
sudo apt-get install oracle-java7-set-default
java -version

## Uninstall
## sudo apt-get remove oracle-java7-installer

