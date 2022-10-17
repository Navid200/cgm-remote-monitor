#!/bin/bash

echo 
echo "Bringing up the menu"
echo

# We need dialog for this.  This will be removed after installation of dialog is added to the main installation script.
sudo apt-get update
sudo apt-get -y install dialog

#clear #  Clear the screen before placing the next dialog on.

dialog --radiolist "Choose one of the following options."\n\n 12 45 25\
1 "Backup Mongo database" 1 "on"\
2 "Restore a Mongo backup" 2 "off"\
3 "Update executables" 3 "off"\
4 "Install" 4 "off"\
5 "Update/Customize Nightscout" 5 "off"

