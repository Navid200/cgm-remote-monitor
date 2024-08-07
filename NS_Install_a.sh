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


