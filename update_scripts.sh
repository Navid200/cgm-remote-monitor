#!/bin/bash

echo
echo "Fetch the latest scripts from GitHub - Navid200"
echo

cd /xDrip/clone
cd "$(< repo)"  # Go to the 
sudo git pull

sudo chmod 755 *.sh # Change premissions to allow execution by all.
rm -f /xDrip/scripts/*.sh # Remove the existing sh files
sudo cp *.sh /xDrip/scripts # Overwrite the scripts in the scripts directory with the new ones.
rm -rf /xDrip/ConfigServer # Remove the existing ConfigServer directory
sudo cp -r ConfigServer /xDrip/.
cd ..

if [ ! -s /tmp/nodialog_update_scripts ]
then
dialog --colors --msgbox "    \Zr Developed by the xDrip team \Zn\n\n\
Updated scripts will be in effect in a new window." 8 43
clear
fi
 
