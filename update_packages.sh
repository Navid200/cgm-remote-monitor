#!/bin/bash

echo
echo "Install packages. - Navid200"
echo

# Reduce the number of snapshots kept from the default 3 to 2 to reduce disk space usage.
sudo snap set system refresh.retain=2

# Let's upgrade packages if available and install the missing needed packages.
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
  sudo apt-get -y install vis nano screen jq qrencode file net-tools gnupg liblzma5 apt-transport-https lsb-release ca-certificates build-essential
fi

# The last item on the above list of packages must be verified in Status.sh to have been installed.  

# Add log
/xDrip/scripts/AddLog.sh "The packages have been installed" /xDrip/Logs
  
