#!/bin/sh -x

cd /data/git/devops/scripts/

./ubuntu.sh
./git.sh "Nik Khilnani" "nik@khilnani.org"
./python.sh
./docker.sh

