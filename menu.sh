#!/bin/bash

echo
echo "Bringing up the menu"
echo

while :
do
clear #  Clear the screen before placing the next dialog on.

Choice=$(dialog --nocancel --nook --menu "Use the arrow keys to move the cursor.\n\
Press Enter to execute the highlighted option.\n\n" 19 50 11\
 "1" "Backup MongoDB"\
 "2" "Initial Nightscout install"\
 "3" "noip.com association"\
 "4" "Edit Nightscout Variables"\
 "5" "Transfer database from another server"\
 "6" "Update/Customize Nightscout"\
 "7" "Update scripts"\
 "8" "Status"\
 "9" "Reboot server"\
 "10" "Exit" 3>&1 1>&2 2>&3)

case $Choice in
1)
clear
/xDrip/scripts/backupmongo.sh

2)
clear
sudo /xDrip/scripts/NS_Install.sh
;;

3)
clear
sudo /xDrip/scripts/NS_Install2.sh
;;

4)
clear
/xDrip/scripts/variables.sh
;;

5)
clear
sudo /xDrip/scripts/clone_nightscout.sh
;;

6)
clear
sudo /xDrip/scripts/update_nightscout.sh
;;

7)
/xDrip/scripts/update_scripts.sh
;;

8)
clear
/xDrip/scripts/Status.sh
;;

9)
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

10)
cat > /tmp/menu_exit_note << EOF
You will now exit to the shell (terminal).
To return to the menu, enter menu in the terminal.

EOF
cd /tmp
clear
dialog --textbox menu_exit_note 7 54
clear
exit
;;

esac

done
