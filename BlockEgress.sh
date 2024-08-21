#!/bin/bash

echo
echo "Blocking China and/or Australia - Navid200"
echo

# Google charges outgoing traffic greater than 1GB per month.
# However, the 1GB limit does not apply to China and Australia.
# Any outgoing traffic to China and Australia even if less than 1GB will be charged.
# This utility allows us to block traffic to China and or Australia.

if [ "`id -u`" != "0" ]
then
echo "Script needs root - use sudo bash BlockEgress.sh"
echo "Cannot continue.."
exit 5
fi
 
if ! grep -q "net.ipv6.conf.all.disable_ipv6 = 1" /etc/sysctl.conf
then
  cat << EOT >> /etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOT

fi

if [ ! -d "/etc/iptables" ] 
then
  mkdir /etc/iptables
fi

  


echo "### BLOCKING AUSTRALIA EGRESS ###"
echo

ipset -N block-australia hash:net -exist
ipset -F block-australia

if [ -f "/tmp/au.zone" ]
then
	rm /tmp/au.zone
fi

sudo curl -o /tmp/au.zone -sSL "https://www.ipdeny.com/ipblocks/data/countries/au.zone"

if [ $? -eq 0 ]
then
	echo "Download Finished!"
fi

echo

echo -n "Adding Networks to ipset ..."
for net in `cat /tmp/au.zone`
do
	ipset -A block-australia $net
done

echo "Done"

#---------------------------

echo "### BLOCKING Canada EGRESS ###"
echo

ipset -N block-canada hash:net -exist
ipset -F block-canada

if [ -f "/tmp/ca.zone" ]
then
	rm /tmp/ca.zone
fi

sudo curl -o /tmp/ca.zone -sSL "https://www.ipdeny.com/ipblocks/data/countries/ca.zone"

if [ $? -eq 0 ]
then
	echo "Download Finished!"
fi

echo

echo -n "Adding Networks to ipset ..."
for net in `cat /tmp/ca.zone`
do
	ipset -A block-canada $net
done

echo "Done"

#---------------------------

echo "### BLOCKING CHINA EGRESS ###"
echo

ipset -N block-china hash:net -exist
ipset -F block-china

if [ -f "/tmp/cn.zone" ]
then
	rm /tmp/cn.zone
fi

curl -o /tmp/cn.zone -sSL "https://www.ipdeny.com/ipblocks/data/countries/cn.zone"

if [ $? -eq 0 ]
then
	echo "Download Finished!"
fi

echo

echo -n "Adding Networks to ipset ..."
for net in `cat /tmp/cn.zone`
do
	ipset -A block-china $net
done

echo "Done"

echo "### SAVING IPSET RULES ###"
echo

ipset save > /etc/iptables/ipset

echo "Done"

iptables -I OUTPUT -m set --match-set block-australia src -j DROP && sudo iptables -I OUTPUT -m set --match-set block-china src -j DROP -I OUTPUT -m set --match-set block-canada src -j DROP  

iptables-save > /tmp/rules.v4
chown root /tmp/rules.v4
mv /tmp/rules.v4 /etc/iptables/rules.v4

service netfilter-persistent start
service netfilter-persistent save
service netfilter-persistent reload

cat > /etc/systemd/system/ipset-persistent.service << "EOF"
[Unit]
Description=ipset persistent configuration
Before=network.target

# ipset sets should be loaded before iptables
# Because creating iptables rules with names of non-existent sets is not possible
Before=netfilter-persistent.service
Before=ufw.service

ConditionFileNotEmpty=/etc/iptables/ipset

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/sbin/ipset restore -exist -file /etc/iptables/ipset
# Uncomment to save changed sets on reboot
# ExecStop=/sbin/ipset save -file /etc/iptables/ipset
ExecStop=/sbin/ipset flush
ExecStopPost=/sbin/ipset destroy

[Install]
WantedBy=multi-user.target

RequiredBy=netfilter-persistent.service
RequiredBy=ufw.service

EOF

sudo systemctl daemon-reload
sudo systemctl enable ipset-persistent.service
sudo systemctl start ipset-persistent.service
