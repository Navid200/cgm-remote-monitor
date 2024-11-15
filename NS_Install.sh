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

clear
dialog --colors --msgbox "      \Zr Developed by the xDrip team \Zn\n\n\
Some required packages will be installed now.  It will take about 15 minutes to complete.  This terminal needs to be kept open.  Press enter to proceed.\n\n\
If this is not a good time, you can press escape now to cancel." 13 50
if [ $? = 255 ]
then
clear
exit
fi
clear

if [ ! -s /var/SWAP ]
then
echo "Creating swap file"
dd if=/dev/zero of=/var/SWAP bs=1M count=2000
chmod 600 /var/SWAP
mkswap /var/SWAP
fi
swapon 2>/dev/null /var/SWAP

apt update

# node - We install version 16 of node here, which automatically  updates npm to 8.
whichpack=$(node -v)
if [ ! "${whichpack%%.*}" = "v16" ]
then
  /xDrip/scripts/nodesource_setup.sh
  apt-get install nodejs -y
  # Nightscout needs version 6 of npm.  So, we are going to install that version now effectivwely downgrading it.  
  npm install -g npm@6.14.18
fi
# Please don't add any utility installs here.  Please instead, add them to update_packages.sh.

cd /srv

echo "Installing Nightscout"
cd "$(< repo)" 
git reset --hard  # delete any local edits.
git pull  # Update database from remote.

npm install
# sudo npm run postinstall
npm run-script post-generate-keys

for loop in 1 2 3 4 5 6 7 8 9
do
read -t 0.1 dummy
done

# Add log
/xDrip/scripts/AddLog.sh "Installation phase 1 completed" /xDrip/Logs
  
