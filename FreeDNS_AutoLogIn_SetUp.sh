#!/bin/bash

echo
echo "Set up auto login to FreeDNS - Navid200"
echo

freedns=$(wget --spider -S "https://freedns.afraid.org/" 2>&1 | awk '/HTTP\// {print $2}') # This will be 200 if FreeDNS is up.

if [ $freedns -eq 200 ]  # Run the following only if FreeDNS is up.
then

else # If FreeDNS is down
dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\n\
It seems the FreeDNS site is down.  Please try again when FreeDNS is back up." 9 50
cat > /tmp/FreeDNS_Failed << EOF
The FreeDNS site is down.
EOF
fi
