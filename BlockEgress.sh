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

if [ ! -d "/etc/iptables" ] 
then
  sudo mkdir /etc/iptables
fi

  


echo "### BLOCKING AUSTRALIA EGRESS ###"
echo

ipset -N block-australia hash:net -exist
ipset -F block-australia

if [ -f "au.zone" ]
then
	rm au.zone
fi

sudo curl -o au.zone -sSL "https://www.ipdeny.com/ipblocks/data/countries/au.zone"

if [ $? -eq 0 ]
then
	echo "Download Finished!"
fi

echo

echo -n "Adding Networks to ipset ..."
for net in `cat au.zone`
do
	ipset -A block-australia $net
done

echo "Done"

echo "### BLOCKING CHINA EGRESS ###"
echo

ipset -N block-china hash:net -exist
ipset -F block-china

if [ -f "cn.zone" ]
then
	rm cn.zone
fi

sudo curl -o cn.zone -sSL "https://www.ipdeny.com/ipblocks/data/countries/cn.zone"

if [ $? -eq 0 ]
then
	echo "Download Finished!"
fi

echo

echo -n "Adding Networks to ipset ..."
for net in `cat cn.zone`
do
	ipset -A block-china $net
done

echo "Done"

echo "### SAVING IPSET RULES ###"
echo

ipset save > /etc/iptables/ipset

echo "Done"

sudo iptables -I OUTPUT -m set --match-set block-australia src -j DROP && sudo iptables -I OUTPUT -m set --match-set block-china src -j DROP
