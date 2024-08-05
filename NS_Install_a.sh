#!/bin/bash

echo
echo "JamOrHam Nightscout Installer - Designed for Google Compute Minimal Ubuntu 20 micro instance"
echo


if [ ! -s /var/SWAP ]
then
echo "Creating swap file"
sudo dd if=/dev/zero of=/var/SWAP bs=1M count=2000
sudo chmod 600 /var/SWAP
sudo mkswap /var/SWAP
fi
sudo swapon 2>/dev/null /var/SWAP

echo "Installing system basics"
sudo apt-get update
sudo apt-get -y install wget gnupg libcurl4 openssl liblzma5
sudo apt-get -y install dirmngr apt-transport-https lsb-release ca-certificates
sudo apt-get -y install net-tools
sudo apt-get -y install build-essential
# Please don't add any more utilities here.  Please instead, add them to update_packages.sh.

/xDrip/scripts/update_packages.sh
