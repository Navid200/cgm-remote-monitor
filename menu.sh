#!/bin/bash

echo
echo "Bringing up the menu"
echo

while [ true ]
do
clear #  Clear the screen before placing the next dialog on.

Choice=$(dialog --nocancel --menu "Choose one of the following options.\n\n" 15 50 9\
 "1" "Initial Nightscout install"\
 "2" "Transfer database from another server"\
 "3" "Update/Customize Nightscout"\
 "4" "Reboot server"\
 "5" "Terminal" 3>&1 1>&2 2>&3)

case $Choice in
1)
sudo /xDrip/scripts/installation.sh
;;

2)
sudo /xDrip/scripts/clone_nightscout.sh
;;

3)
sudo /xDrip/scripts/update_nightscout.sh
;;

4)
dialog --yesno "Are you sure you want to reboot the server?\n
If you do, all unsaved open files will close without saving.\n"  8 50
response=$?
if [ $response = 255 ] || [ $response = 1 ]
then
clear
else
sudo reboot
fi
;;

5)
# Clear before exiting. 
clear
exit
;;

esac

done
