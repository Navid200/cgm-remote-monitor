#!/bin/bash

echo 
echo "Bringing up the menu"
echo

# We need dialog for this.  This will be removed after installation of dialog is added to the main installation script.
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
/srv/nightscout-vps/menu.sh # restart the menu script.
fi

# Clear before exit.
clear
echo "$Choice"

case $Choice in
1)
exec 3>&1
Filename=$(dialog --ok-label "Submit" --form "Enter a name for the backup file" 12 50 0 "file name" 1 1 "$filename" 1 14 25 0 2>&1 1>&3) 
 response=$?
if [ ! $response = 255 ] & [ ! $response = 1 ]
then
mongodump --gzip --archive=$Filename 
exec 3>&- 
fi
/srv/nightscout-vps/menu.sh;;

5)
dialog --yesno "Are you sure you want to reboot the server?\n
If you do, all unsaved open files will close without saving.\n"  8 50
response=$?
if [ $response = 255 ] || [ $response = 1 ]
then
clear
/srv/nightscout-vps/menu.sh
else
sudo reboot 
fi ;;

7)
sudo /srv/nightscout-vps/update_nightscout.sh
/srv/nightscout-vps/menu.sh;;

8)
# Clear before exiting. 
clear
exit;;

esac

