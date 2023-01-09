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
clear
echo "$baseurl"

qrencodev=$(qrencode --version | sed -n 1p)
if [ "$qrencodev" = "" ]
then
  sudo apt-get update
  sudo apt-get install qrencode
fi  

qrencode -s 6 -t UTF8 "$baseurl"
dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\n\
The following line is the base URL.  An app that needs to upload to Nightscout requires it.  Please don't post in a public forum.\n\n
$baseurl" 16 60

# qrencode -s 6 -t UTF8 "$baseurl"
  
  
