#!/bin/sh -x

##############################################
# Enable networking and basic display
##############################################

sed -i -e 's/ONBOOT=no/ONBOOT=yes/g' /etc/sysconfig/network-scripts/ifcfg-eth0

sed -i -e 's/rhgb quiet/rhgb quiet vga=791/g' /etc/grub.conf

/etc/rc.d/init.d/network start

##############################################
# Basic software installation
##############################################

yum -y update
yum -y groupinstall "Development Tools"
yum -y install man
yum -y install wget
yum -y install curl

##############################################
# Virtual Box Guest Additions
##############################################

mount /dev/cdrom /mnt
cd /mnt
./VBoxLinuxAdditions.run

##############################################
# vagrant user setup
##############################################

adduser vagrant

echo 'vagrant' | passwd vagrant --stdin

echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

cd /home/vagrant

##############################################
# vagrant ssh setup
##############################################

sed -i -e 's/Defaults    requiretty/### Defaults    requiretty/g' /etc/sudoers

mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh

curl -o /home/vagrant/.ssh/authorized_keys https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
chmod 600 /home/vagrant/.ssh/authorized_keys

chown -R vagrant:vagrant /home/vagrant/.ssh

##############################################
# SSH setup for vagrant
##############################################

yum -y install openssh-server

# service sshd restart
/sbin/service sshd start

##############################################
# Useful Info
##############################################

ifconfig

cat /etc/passwd | grep "vagrant"

##############################################



