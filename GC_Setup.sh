#!/bin/bash

echo
echo "Bringing up the Google Cloud menu" - Navid200
echo

while :
do

clear
Choice=$(dialog --colors --nocancel --nook --menu "\
      \Zr Developed by the xDrip team \Zn\n\n
Use the arrow keys to move the cursor.\n\
Press Enter to execute the highlighted option.\n\
Press escape to return to the main menu\n" 19 50 8\


 "1" "Update platform"\
 "2" "Bootstrap"\

 3>&1 1>&2 2>&3)

case $Choice in


1)
cd /srv
cd "$(< repo)"  # Go to the local database
sudo git reset --hard  # delete any local edits.
sudo git pull  # Update database from remote.
sudo chmod 755 update_scripts.sh
sudo cp -f update_scripts.sh /xDrip/scripts/.
clear
sudo /xDrip/scripts/update_scripts.sh
sudo /xDrip/scripts/update_packages.sh
;;

2)
curl https://raw.githubusercontent.com/jamorham/nightscout-vps/vps-1/bootstrap.sh | bash
;;


esac
