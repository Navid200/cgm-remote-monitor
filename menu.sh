#!/bin/bash

echo
echo "Bringing up the menu" - Navid200
echo

while :
do

clear
Choice=$(dialog --colors --nocancel --nook --menu "\
      \Zr Developed by the xDrip team \Zn\
  \n\n
Use the arrow keys to move the cursor.\n\
Press Enter to execute the highlighted option.\n\n" 24 50 14\
 "1" "Status"\
 "2" "Installation phase 1 - 15 minutes"\
 "3" "Installation phase 2 - 5 minutes"\
 "4" "Edit variables in a browser"\
 "5" "Copy Variables from Heroku"\
 "6" "Update scripts"\
 "7" "Backup MongoDB"\
 "8" "Restore MongoDB backup"\
 "9" "FreeDNS Setup"\
 "10" "Copy data from another Nightscout"\
 "11" "Customize Nightscout"\
 "12" "Reboot server (Nightscout)"\
 "13" "Exit to shell (terminal)"\
 3>&1 1>&2 2>&3)

case $Choice in

1)
/xDrip/scripts/Status.sh
;;

2)
sudo /xDrip/scripts/NS_Install.sh
;;

3)
sudo /xDrip/scripts/NS_Install2.sh
;;

4)
/xDrip/scripts/varserver.sh
;;

5)
/xDrip/scripts/GetHerokuVars.sh
;;

6)
cd /srv
cd "$(< repo)"  # Go to the local database
sudo git reset --hard  # delete any local edits.
sudo git pull  # Update database from remote.
sudo chmod 755 update_scripts.sh
sudo cp -f update_scripts.sh /xDrip/scripts/.
clear
sudo /xDrip/scripts/update_scripts.sh
;;

7)
/xDrip/scripts/backupmongo.sh
;;

8)
/xDrip/scripts/restoremongo.sh
;;

9)
clear
sudo /xDrip/scripts/ConfigureFreedns.sh
;;

10)
clear
sudo /xDrip/scripts/clone_nightscout.sh
;;

11)
sudo /xDrip/scripts/update_nightscout.sh
;;

12)
dialog --colors --yesno "     \Zr Developed by the xDrip team \Zn\n\n\
Are you sure you want to reboot the server?\n
If you do, all unsaved open files will close without saving.\n"  10 50
response=$?
if [ $response = 255 ] || [ $response = 1 ]
then
clear
else
sudo reboot
fi
;;

13)
cd /tmp
clear
dialog --colors --msgbox "        \Zr Developed by the xDrip team \Zn\n\n\
You will now exit to the shell (terminal).  To return to the menu, enter menu in the terminal." 9 50
clear
exit
;;

esac

done
 
