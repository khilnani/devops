#!/bin/sh

# Check for command args
if [[ -z "$1" ]] ; then
	echo "USAGE: $0 USER"
    exit 1
else
  echo "Nginx USER: $1"
fi

htpasswd -c /etc/nginx/.htpasswd $1
