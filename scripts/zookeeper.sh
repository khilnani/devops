#!/bin/bash -x

############################################
CWD=`pwd`
cd /tmp/
############################################

sudo apt-get install -y zookeeper wget supervisor dnsutils
rm -rf /var/lib/apt/lists/*
sudo apt-get clean

cat >/etc/supervisor/conf.d/zookeeper.conf <<EOL
[program:zookeeper]
command=/usr/share/zookeeper/bin/zkServer.sh start-foreground
autostart=true
autorestart=true
EOL


############################################
cd $CWD
############################################
