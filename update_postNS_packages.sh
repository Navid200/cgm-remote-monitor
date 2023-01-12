#!/bin/bash

echo
echo "Install packages that are installed after Nightscout only if they are not installed already. - Navid200"
echo

# Let's install the missing needed packages.

# node
whichpack=$(node -v)
if [ ! "$whichpack" = "v16.*" ]
then
  curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &&\
  sudo apt-get install -y nodejs
fi 
  
