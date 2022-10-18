#!/bin/bash

echo
echo "Fetch the latest scripts from GitHub"
echo


if [ "`id -u`" != "0" ]
then
echo "Script needs root - use sudo bash update_scripts.sh"
echo "Cannot continue.."
exit 5
fi

cd /tmp
#if [ -s ./nightscout-vps ]
if [ -s ./cgm-remote-monitor ]
then
#sudo rm -r nightscout-vps # If the directory already exists in the tmp directory, delete it.
sudo rm -r cgm-remote-monitor # If the directory already exists in the tmp directory, delete it.
fi
#sudo git clone https://github.com/jamorham/nightscout-vps.git # Clone the install repository.
sudo git clone https://github.com/Navid200/cgm-remote-monitor.git # Clone the install repository.
#cd nightscout-vps
cd cgm-remote-monitor
#sudo git checkout vps-1
sudo git checkout Navid_2022_10_14c
sudo git pull
sudo chmod 755 *.sh # Change premissions to allow execution by all.
sudo mv -f *.sh /xDrip/scripts # Overwrite the scripts in the scripts directory with the new ones.
cd ..
# sudo rm -r nightscout-vps # Delete the temporary pull directory.
sudo rm -r cgm-remote-monitor # Delete the temporary pull directory.
