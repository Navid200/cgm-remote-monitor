#!/bin/bash

echo
echo "Bringing up the utilities menu" - Navid200
echo

while :
do

clear
Choice=$(dialog --colors --nocancel --nook --menu "\
      \Zr Developed by the xDrip team \Zn\
  \n\n
Use the arrow keys to move the cursor.\n\
Press Enter to execute the highlighted option.\n\n" 20 50 6\
 "1" "Status"\
 "2" "Edit variables using a test editor"\
 "3" "Copy data from another Nightscout"\
 "4" "FreeDNS Setup"\
 "5" "Customize Nightscout"\
 "6" "Return"\
 3>&1 1>&2 2>&3)

case $Choice in

1)
/xDrip/scripts/Status.sh
;;

2)
/xDrip/scripts/variables.sh
;;

3)
clear
sudo /xDrip/scripts/clone_nightscout.sh
;;

4)
clear
sudo /xDrip/scripts/ConfigureFreedns.sh
;;

5)
sudo /xDrip/scripts/update_nightscout.sh
;;

6)
/xDrip/scripts/menu.sh
;;

esac

done
 
