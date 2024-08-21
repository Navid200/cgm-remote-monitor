#!/bin/bash

echo
echo "Blocking China and/or Australia - Navid200"
echo

# Google charges outgoing traffic greater than 1GB per month.
# However, the 1GB limit does not apply to China and Australia.
# Any outgoing traffic to China and Australia even if less than 1GB will be charged.
# This utility allows us to block traffic to China and or Australia.

sudo apt-get update
sudo apt-get -y install build-essential netfilter-persistent ipset
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean false | sudo debconf-set-selections
sudo apt-get -y install iptables-persistent
 
if ! grep -q "net.ipv6.conf.all.disable_ipv6 = 1" /etc/sysctl.conf
then
  sudo cat << EOT >> /etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOT

fi
