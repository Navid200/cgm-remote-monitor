#!/bin/bash

echo
echo "Log into the FreeDNS site in the background. - Navid200"
echo

# This could also run in the background.  So, it should contain no dialog.  


echo "Installing Nightscout"
cd "$(< repo)" 
sudo git reset --hard  # delete any local edits.
sudo git pull  # Update database from remote.


# Add log
rm -rf /tmp/Logs
echo -e "Logged into FreeDNS.      $(date)\n" | cat - /xDrip/Logs > /tmp/Logs
sudo /bin/cp -f /tmp/Logs /xDrip/Logs
 
