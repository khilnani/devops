#!/bin/bash -x

############################################
CWD=`pwd`
cd /tmp/
############################################

sudo apt-get install -y wget supervisor dnsutils
rm -rf /var/lib/apt/lists/*
sudo apt-get clean
wget http://apache.mirrors.spacedump.net/kafka/$KAFKA_VERSION/$KAFKA_NAME.tgz -O /tmp/$KAFKA_NAME.tgz
sudo tar xfz /tmp/$KAFKA_NAME.tgz -C $KAFKA_INSTALL_DIR
rm /tmp/$KAFKA_NAME.tgz


cat <<EOL >/etc/supervisor/conf.d/zookeeper.conf
[program:zookeeper]
command=$KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties
priority=1
autostart=true
autorestart=unexpected
startsecs=10
stopwaitsecs=10
user=root
stdout_logfile=/var/log/supervisor/zookeeper.log
stderr_logfile=/var/log/supervisor/zookeeper.error.log
EOL

cat <<EOL >/etc/supervisor/conf.d/kafka.conf
[program:kafka]
priority=10
command=$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
autostart=true
autorestart=unexpected
startsecs=10
stopwaitsecs=10
user=root
stdout_logfile=/var/log/supervisor/kafka.log
stderr_logfile=/var/log/supervisor/kafka.error.log
EOL

sudo service supervisor restart

############################################
cd $CWD
############################################
