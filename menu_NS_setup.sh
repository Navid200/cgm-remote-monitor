#!/bin/bash

echo
echo "Bringing up the Nightscout setup menu" - Navid200
echo

clear
Choice=$(dialog --colors --nocancel --nook --menu "\
      \Zr Developed by the xDrip team \Zn\
  \n\n
Use the arrow keys to move the cursor.\n\
Press Enter to execute the highlighted option.\n\
Press escape to return to the main menu\n" 19 50 8\
 "1" "Edit variables using a text editor"\
 "2" "Edit variables using a web browser"\
 "3" "Customize Nightscout"\
 3>&1 1>&2 2>&3)

case $Choice in


1)
/xDrip/scripts/variables.sh
;;

2)
/xDrip/scripts/varserver.sh
;;

3)
sudo /xDrip/scripts/update_nightscout.sh
;;

esac
  
