#!/bin/sh

# Check for command args
if [[ $# -eq 0 ]] ; then
	echo "USAGE: $0 EMAIL DOMAIN"
    exit 1
else
	echo "Email: $1 Domain: $2"
fi

# Check for env variable
if [[ -z "$LETSENCRYPT_HOME" ]] ; then
	echo "LETSENCRYPT_HOME not defined"
	exit 1
else
	echo "Using $LETSENCRYPT_HOME"
fi

# Check if installed
if [ -d "$LETSENCRYPT_HOME" ]; then
	echo "LetsEncrypt install exists"
else
	echo "Cloning LetsEncrypt repo to $LETSENCRYPT_HOME"
	git clone https://github.com/letsencrypt/letsencrypt $LETSENCRYPT_HOME
fi

# Install
cd $LETSENCRYPT_HOME
pwd
echo "Running LetsEncrypt"
./certbot-auto certonly --standalone --standalone-supported-challenges http-01 --agree-tos --email $1 -d $2

