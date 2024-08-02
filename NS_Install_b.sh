#!/bin/bash

echo
echo "JamOrHam Nightscout Installer - Designed for Google Compute Minimal Ubuntu 20 micro instance"
echo

if [ "`id -u`" != "0" ]
then
echo "Script needs root - use sudo bash NS_Install.sh"
echo "Cannot continue.."
exit 5
fi

clear
dialog --colors --msgbox "      \Zr Developed by the xDrip team \Zn\n\n\
Some required packages will be installed now.  It will take about 15 minutes to complete.  This terminal needs to be kept open.  Press enter to proceed.\n\n\
If this is not a good time, you can press escape now to cancel." 13 50
if [ $? = 255 ]
then
clear
exit
fi
clear

# Create mongo user and admin.
echo -e "use Nightscout\ndb.createUser({user: \"username\", pwd: \"password\", roles:[\"readWrite\"]})\nquit()" | mongosh
echo -e "use admin\ndb.createUser({ user: \"mongoadmin\" , pwd: \"mongoadmin\", roles: [\"userAdminAnyDatabase\", \"dbAdminAnyDatabase\", \"readWriteAnyDatabase\"]})\nquit()" | mongosh


  
