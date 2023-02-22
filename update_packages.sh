#!/bin/bash

echo
echo "Install packages only if they are not installed already. - Navid200"
echo

# Let's install the missing needed packages.

if [ "`id -u`" != "0" ]
then
  echo "Script needs root."
  echo "Cannot continue.."
  exit 5
fi

sudo apt-get update

# vis
whichpack=$(which vis)
if [ "$whichpack" = "" ]
then
  sudo apt-get -y install vis
fi

# nano
whichpack=$(which nano)
if [ "$whichpack" = "" ]
then
  sudo apt-get -y install nano
fi

# screen
whichpack=$(which screen)
if [ "$whichpack" = "" ]
then
  sudo apt-get -y install screen
fi

# jq
whichpack=$(which jq)
if [ "$whichpack" = "" ]
then
  sudo apt-get -y install jq
fi

# qrencode
whichpack=$(which qrencode)
if [ "$whichpack" = "" ]
then
  sudo apt-get -y install qrencode
fi

# mongo
whichpack="$(mongod --version | sed -n 1p)"
if [ ! "${whichpack%%.*}" = "db version v3" ]
then
  sudo apt-get -y install mongodb-server
fi

# node
whichpack=$(node -v)
if [ ! "${whichpack%%.*}" = "v14" ]
then
  curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash - &&\
  sudo apt-get install -y nodejs
fi 

# file
whichpack=$(which file)
if [ "$whichpack" = "" ]
then
  sudo apt-get -y install file
fi  

# Add log
echo -e "The packages have been installed     $(date)\n" >> /xDrip/Logs
 
