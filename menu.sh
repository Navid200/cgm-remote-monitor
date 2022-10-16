#!/bin/bash

echo
echo "Bringing up the menu"
echo

# We need dialog for this.  This will be removed after installation of dialog is added to the main installation
script.
#sudo apt-get update
#sudo apt-get -y install dialog

clear #  Clear the screen before placing the next dialog on.

Choice=$(dialog --nocancel --menu "Choose one of the following options.\n\n" 15 50 9\
 "1" "Backup Mongo database"\
 "2" "Restore a Mongo backup"\
 "3" "Transfer database from another server"\
 "4" "Update executables"\
 "5" "Reboot server"\
 "6" "Install Nightscout"\
 "7" "Update/Customize Nightscout"\
 "8" "Terminal" 3>&1 1>&2 2>&3)

response=$?
if [ $response = 255 ] #  Escape was chosen
then
clear # Clear the screen before exiting.
#echo "Escape"
#echo "Cannot continue."
#exit 5
sudo /home/mymark14/menu.sh # restart the menu script.
fi

# Clear before exit.
clear
echo "$Choice"

case $Choice in

7)
sudo /srv/nightscout-vps/update_nightscout.sh;;

8)
# Clear before exiting. 
clear
exit;;

esac
