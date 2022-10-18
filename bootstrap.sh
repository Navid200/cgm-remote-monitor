#!/bin/sh
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"

echo 
echo "Bootstrapping the menu - JamOrHam"
echo

sudo apt-get update
sudo apt-get -y install wget bash
sudo apt-get -y install dialog

cd /tmp
if [ ! -s menu.sh ]
then

wget https://raw.githubusercontent.com/Navid200/cgm-remote-monitor/Navid_2022_10_14c/menu.sh
# wget https://raw.githubusercontent.com/jamorham/nightscout-vps/vps-1/menu.sh
if [ ! -s menu.sh ]
then
echo "UNABLE TO DOWNLOAD MENU SCRIPT! - cannot continue - please try again!"
exit 5
fi
fi

sudo chmod 755 menu.sh
/tmp/menu.sh

#if [ "$SSH_TTY" = "" ]
#then
#echo "Must be run from ssh session"
#exit 5
#fi

#echo
#echo "Running installer"
#echo
#sudo < $SSH_TTY bash installation.sh
#echo
