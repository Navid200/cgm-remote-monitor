#!/bin/bash

echo
echo "JamOrHam Nightscout Installer - Designed for Google Compute Minimal Ubuntu 20 micro instance"
echo

if [ "`id -u`" != "0" ]
then
echo "Script needs root - use sudo bash NS_Install.sh"
echo "Cannot continue.."
exit 5
fi


cd /srv 
cd "$(< repo)" 

/xDrip/scripts/wait_4_completion.sh
apt-get update || apt-get update

npm install 


  
