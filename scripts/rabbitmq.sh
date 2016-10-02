#!/bin/bash -x

# Check for command args
if [[ $# -eq 0 ]] ; then
	echo "USAGE: $0 USER PASSWORD"
    exit 1
else
	echo "RabbitMQ USER: $1"
fi


############################################
CWD=`pwd`
cd /tmp/
############################################

sudo echo 'deb http://www.rabbitmq.com/debian/ stable main' |
        sudo tee /etc/apt/sources.list.d/rabbitmq.list
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc |
        sudo apt-key add -
sudo apt-get -y update
sudo apt-get -y install rabbitmq-server

# Enable management plugin
rabbitmq-plugins enable rabbitmq_management

# Restart
invoke-rc.d rabbitmq-server stop
invoke-rc.d rabbitmq-server start

# Manage users
rabbitmqctl add_vhost test
rabbitmqctl add_user $1 $2
rabbitmqctl set_user_tags $1 administrator
rabbitmqctl delete_user guest

# Install command line
wget http://127.0.0.1:15672/cli/rabbitmqadmin -O /usr/local/bin/rabbitmqadmin
chmod 755 /usr/local/bin/rabbitmqadmin
############################################
cd $CWD
############################################
