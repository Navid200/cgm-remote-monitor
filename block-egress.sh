#!/bin/bash

echo "### BLOCKING AUSTRALIA EGRESS ###"
echo

ipset -N block-australia hash:net -exist
ipset -F block-australia

if [ -f "au.zone" ]
then
	rm au.zone
fi

curl -o au.zone -sSL "https://www.ipdeny.com/ipblocks/data/countries/au.zone"

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

curl -o cn.zone -sSL "https://www.ipdeny.com/ipblocks/data/countries/cn.zone"

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
