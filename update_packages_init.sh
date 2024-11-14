#!/bin/bash

echo
echo "Install packages before Nightscout. - Navid200"
echo

# Let's upgrade packages required before we can install Nightscout if available.
sudo apt-get update

# packages
whichpack=$(which file)
if [ "$whichpack" = "" ]
then
  sudo apt-get -y install vis jq net-tools gnupg liblzma5 lsb-release build-essential
fi

# node - We install version 16 of node here, which automatically  updates npm to 8.
whichpack=$(node -v)
if [ ! "${whichpack%%.*}" = "v16" ]
then
sudo /xDrip/scripts/nodesource_setup.sh
# sudo apt install -y nodejs
sudo apt-get install nodejs -y
# Nightscout needs version 6 of npm.  So, we are going to install that version now effectivwely downgrading it.  
sudo npm install -g npm@6.14.18
fi

# Add log
/xDrip/scripts/AddLog.sh "The initial packages have been updated" /xDrip/Logs
  
