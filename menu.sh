#!/bin/bash

echo
echo "Bringing up the menu"
echo

# We need dialog for this.  This will be removed after installation of dialog is added to the main installation
script.
#sudo apt-get update
#sudo apt-get -y install dialog

clear #  Clear the screen before placing the next dialog on.

Choice=$(dialog --menu "Choose one of the following options.\n\n" 15 50 7\
 "1" "Backup Mongo database"\
 "2" "Restore a Mongo backup"\
 "3" "Transfer database from another server"\
 "4" "Update executables"\
 "5" "Reboot server"\
 "6" "Install Nightscout"\
 "7" "Update/Customize Nightscout" 3>&1 1>&2 2>&3)

response=$?
if [ $response = 255 ] #  Escape was chosen
then
clear # Clear the screen before exiting.
echo "Escape"
echo "Cannot continue."
exit 5
fi
if [ $response = 1 ] #  Cancelled
then
clear # Clear the screen before exiting.
echo "Cancel"
echo "Cannot continue."
exit 5
fi

echo "$Choice"

