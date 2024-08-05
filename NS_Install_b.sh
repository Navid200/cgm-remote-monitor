#!/bin/bash

echo "Installing system basics"
sudo apt-get update
sudo apt-get -y install dirmngr apt-transport-https lsb-release ca-certificates
sudo apt-get -y install net-tools
sudo apt-get -y install build-essential
# Please don't add any more utilities here.  Please instead, add them to update_packages.sh.

/xDrip/scripts/update_packages.sh

  
