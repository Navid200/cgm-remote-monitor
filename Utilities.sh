#!/bin/bash

echo
echo "Bringing up the utilities menu" - Navid200
echo

clear
Choice=$(dialog --colors --nocancel --nook --menu "\
      \Zr Developed by the xDrip team \Zn\
  \n\n
Use the arrow keys to move the cursor.\n\
Press Enter to execute the highlighted option.\n\n" 18 50 8\
 "1" "Logs"\
 "2" "Installation phase 1 - 15 minutes"\
 "3" "Installation phase 2 - 5 minutes"\
 "4" "Edit variables using a text editor"\
 "5" "Copy data from another Nightscout"\
 "6" "FreeDNS Setup"\
 "7" "Customize Nightscout"\
 "8" "Bootstrap"\
 3>&1 1>&2 2>&3)

case $Choice in

1)
clear
dialog --colors --textbox /xDrip/Logs 26 70

# "     \Zr Developed by the xDrip team \Zn\n\n\

;;

2)
sudo /xDrip/scripts/NS_Install.sh
;;

3)
sudo /xDrip/scripts/NS_Install2.sh
;;

4)
/xDrip/scripts/variables.sh
;;

5)
clear
sudo /xDrip/scripts/clone_nightscout.sh
;;

6)
clear
sudo /xDrip/scripts/ConfigureFreedns.sh
;;

7)
sudo /xDrip/scripts/update_nightscout.sh
;;

8)
curl https://raw.githubusercontent.com/jamorham/nightscout-vps/vps-1/bootstrap.sh | bash
;;

esac
 
