#!/bin/bash -x

# Check for command args
if [[ $# -eq 0 ]] ; then
	echo "USAGE: $0 NAME EMAIL"
    exit 1
else
	echo "git Name: $1 Email: $2"
fi

git config --global user.name "$1"
git config --global user.email "$2"
git config --global push.default simple
