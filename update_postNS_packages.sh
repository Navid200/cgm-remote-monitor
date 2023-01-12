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

# Add log
rm -rf /tmp/Logs
echo -e "The post-NS packages have been updated     $(date)\n" | cat - /xDrip/Logs > /tmp/Logs
sudo /bin/cp -f /tmp/Logs /xDrip/Logs
  
