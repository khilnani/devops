#!/bin/sh -x

##############################################
# Setup networking and vga
##############################################

sed -i -e 's/ONBOOT=no/ONBOOT=yes/g' /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i -e 's/rhgb quiet/rhgb quiet vga=791/g' /etc/grub.conf
/etc/rc.d/init.d/network start

##############################################
# Add users
##############################################
# usermod -p `openssl PASSWORD`

adduser nkhilnani

##############################################
# Install core software
##############################################

yum -y groupinstall "Development Tools"
yum -y install man wget curl

##############################################
# Install Virtual Box Guest Addition
##############################################

mount /dev/cdrom /mnt
cd /mnt
./VBoxLinuxAdditions.run

##############################################
# Reminders
##############################################

echo "Type '/sbin/shutdown -r|h now' to reboot."
echo "Type 'user add NAME' to add a user."
echo "Type 'passwd NAME' to change password."

##############################################
