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
 "4" "QR code to make xDrip master"\
 "5" "Edit variables using a text editor"\
 "6" "Copy data from another Nightscout"\
 "7" "FreeDNS Setup"\
 "8" "Customize Nightscout"\
 "9" "Bootstrap"\
 3>&1 1>&2 2>&3)

case $Choice in

1)
clear
dialog --colors --title "\Zr Developed by the xDrip team \Zn"   --textbox /xDrip/Logs 26 74 

# "     \Zr Developed by the xDrip team \Zn\n\n\

;;

2)
sudo /xDrip/scripts/NS_Install.sh
;;

3)
sudo /xDrip/scripts/NS_Install2.sh
;;

4)
/xDrip/scripts/qrCodeMaster.sh
;;

5)
/xDrip/scripts/variables.sh
;;

6)
clear
sudo /xDrip/scripts/clone_nightscout.sh
;;

7)
clear
sudo /xDrip/scripts/ConfigureFreedns.sh
;;

8)
sudo /xDrip/scripts/update_nightscout.sh
;;

9)
curl https://raw.githubusercontent.com/jamorham/nightscout-vps/vps-1/bootstrap.sh | bash
;;

esac
 
