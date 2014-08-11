#!/bin/bash
### Edit this section for your VPN Setup
SSLVpn="ssl.example.com"
SearchDomain="example.com"
DNSServer="192.168.1.1"   
# Below the 192.168.1.1 is a static example of an internal DNS Server
###
if [ ! -f /dev/net/tun ]; then
        tunctl -t tap1 -f /dev/net/tun 
fi
mknod /dev/net/tun0 c 10 200
cp /etc/resolv.conf ~/.resolv.conf
echo "nameserver ${DNSServer}" > /etc/resolv.conf
echo "search ${SearchExample}" >> /etc/resolv.conf
cat ~/.resolv.conf >> /etc/resolv.conf
openconnect -s /etc/vpnc/vpnc-script ${SSLVpn}
cat ~/.resolv.conf > /etc/resolv.conf
rm /dev/net/tun0
