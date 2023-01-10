#!/bin/bash

echo
echo "Show the base URL required to become master" - Navid200
echo

HOSTNAME=""
. /etc/free-dns.sh

. /etc/nsconfig
apisec=$API_SECRET

if [ "$(node -v)" = "" ] || [ "$HOSTNAME" = "" ] || [ "$apisec" = "" ] # If Node.js is not installed or there is no hostname or password
then
clear
dialog --colors --msgbox "     \Zr Developed by the xDrip team \Zn\n\n\
You need to complete Nightscout installation and have a hostname and API_SECRET." 9 50
exit
fi

baseurl="https://$apisec@$HOSTNAME/api/v1/"

qrencodev=$(qrencode --version | sed -n 1p)
if [ "$qrencodev" = "" ]
then
  sudo apt-get update
  sudo apt-get install qrencode
fi  

clear
dialog --colors --msgbox "            \Zr Developed by the xDrip team \Zn\n\n\
The following line is the base URL, which an app would need in order to upload to Nightscout.  Don't disclose.\n\n\Zr\Z5 $baseurl \Zn\n\n\
Press enter for a QR code that with xDrip can scan to set it up as master." 13 60

arg=["$baseurl"]

clear
echo "Developed by the xDrip team"
echo ""
echo "Use auto configure in xDrip to scan this QR code to set it up as master."
#qrencode -s 6 -t UTF8 "$baseurl"
qrencode -s 6 -t UTF8 {"rest":{"endpoint":$arg}}
read -p "Press enter to return to the menu."
  
