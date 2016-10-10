#!/bin/sh

echo "Installing Python libs"

pip install ndg-httpsclient --upgrade
#pip install pyopenssl ndg-httpsclient pyasn1 --upgrade
pip install requests[security] --upgrade

pip install awscli --upgrade

pip install virtualenvwrapper --upgrade

if grep -q "WORKON_HOME" ~/.bashrc; then
    echo "virtualenv already in ~/.bashrc"
else
    echo 'export WORKON_HOME=$HOME/.virtualenvs' >> ~/.bashrc
    echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.bashrc
fi
