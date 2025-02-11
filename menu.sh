#!/bin/bash

echo
echo "Bringing up the menu" - Navid200
echo

while :
do

clear
Choice=$(dialog --colors --nocancel --nook --menu "\
        \Zr Developed by the xDrip team \Zn\n\n
Use the arrow keys to move the cursor.\n\
Press Enter to execute the highlighted option.\n\n" 19 50 9\
 "1" "Status (may take up to 2 minutes.)"\
 "2" "Logs"\
 "3" "Google Cloud setup"\
 "4" "Nightscout setup"\
 "5" "xDrip setup"\
 "6" "Data"\
 "7" "Reboot server (Nightscout)"\
 "8" "Support"\
 "9" "Exit to shell (terminal)"\
 3>&1 1>&2 2>&3)

 clear

case $Choice in

1)
/xDrip/scripts/Status.sh
;;

2)
dialog --colors --title "\Zr Developed by the xDrip team \Zn"   --textbox /xDrip/Logs 26 74 
;;

3)
/xDrip/scripts/menu_GC_Setup.sh
;;

4)
/xDrip/scripts/menu_NS_setup.sh
;;

5)
/xDrip/scripts/menu_xDripSetup.sh
;;

6)
/xDrip/scripts/menu_Data.sh
;;

7)
dialog --colors --yesno "       \Zr Developed by the xDrip team \Zn\n\n\
Are you sure you want to reboot the server?\n
If you do, all unsaved open files will close without saving.\n"  9 50
response=$?
if [ $response = 255 ] || [ $response = 1 ]
then
clear
else
/xDrip/scripts/reboot.sh
fi
;;

8)
clear
dialog --colors --infobox "                      \Zr Developed by the xDrip team \Zn\n\n\n\
Press any key to return to the main menu." 17 80

#Copy the hyperlink below without using CTRL+C and paste it into your web browser.\n\n\

tput civis
printf '          Developed by the xDrip team\n\n'
printf '                 Support\n\n\n'
printf '>  \e]8;;https://navid200.github.io/xDrip/docs/Nightscout/GCNS/Tips.html\e\\Tips\e]8;;\e\\\n'
echo ""
printf '>  \e]8;;https://navid200.github.io/xDrip/docs/Nightscout/GCNS/FAQ.html\e\\FAQ\e]8;;\e\\\n'
echo ""
printf '>  \e]8;;https://navid200.github.io/xDrip/docs/Nightscout/GCNS/Troubleshooting.html\e\\Troubleshooting\e]8;;\e\\\n'
echo ""
printf '>  \e]8;;https://github.com/NightscoutFoundation/xDrip/discussions\e\\Contact us\e]8;;\e\\\n\n\n'
echo ""
echo "Press any key to return to the main menu."
read -p "" -n1 -s
tput cnorm

#FAQ: \Z1 https://navid200.github.io/xDrip/docs/Nightscout/GCNS/FAQ.html \Zn\n\n\
#Troubleshooting:  \Z1 https://navid200.github.io/xDrip/docs/Nightscout/GCNS/Troubleshooting.html \Zn\n\n\
#Contact us: \Z1 https://github.com/NightscoutFoundation/xDrip/discussions \Zn\n\n\n\
#Press any key to return to the main menu." 17 80
#tput civis
#read -p "" -n1 -s
#tput cnorm
;;

9)
cd /tmp
clear
dialog --colors --msgbox "        \Zr Developed by the xDrip team \Zn\n\n\
You will now exit to the shell (terminal).  To return to the menu, enter \"menu\" in the terminal without the quotes." 9 50
clear
exit
;;

esac

done

 
