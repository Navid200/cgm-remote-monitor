#!/bin/bash

echo 
echo "Bringing up the menu"
echo

# We need dialog for this.  This will be removed after installation of dialog is added to the main installation script.
sudo apt-get update
sudo apt-get -y install dialog

clear #  Clear the screen before placing the next dialog on.
dialog --radiolist "Choose one of the following options.\n\n
12 45 25\
"Backup Mongo database" 1 on\
"Restore a Mongo backup" 2 off\
"Update executables" 3 off\
"Install" 4 off\
"Update/Customize Nightscout" 5 off
