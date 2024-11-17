#!/bin/bash

echo
echo "Install packages. - Navid200"
echo

# Reduce the number of snapshots kept from the default 3 to 2 to reduce disk space usage.
sudo snap set system refresh.retain=2

# Let's upgrade or install remaining missing packages if available.
sudo apt-get update

#Ubuntu upgrade available
# NextUbuntu="$(apt-get -s upgrade | grep 'Inst base' | awk '{print $4}' | sed 's/(//')"
# if [ "$NextUbuntu" = "11ubuntu5.8" ] # Only upgrade if we have tested the next release
#then
#   sudo apt-get -y upgrade
# fi

# packages
whichpack=$(which file)
if [ "$whichpack" = "" ]
then
 sudo apt-get -y install nginx python3-certbot-nginx inetutils-ping ca-certificates apt-transport-https lsb-release vis nano screen jq qrencode file
fi

# The last item on the above list of packages must be verified in Status.sh to have been installed.  

# Add log
/xDrip/scripts/AddLog.sh "Additional packages have been installed" /xDrip/Logs
  
