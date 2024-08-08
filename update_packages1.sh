#!/bin/bash

echo
echo "Install packages only if they are not installed already. - Navid200"
echo

# Please keep in mind that what you add here is run during a fresh installation as well as during an update.
# Therefore, you must only install if it is not installed already to avoid wasting time.  

# Reduce the number of snapshots kept from the default 3 to 2 to reduce disk space usage.
sudo snap set system refresh.retain=2

# Fixing "Daemon using outdated libraries prompt interruption"
# https://askubuntu.com/questions/1367139/apt-get-upgrade-auto-restart-services
if [ ! -s /etc/needrestart/conf.d/no-prompt.conf ] # Create a new conf.d file only if one does not exit already.
then
  cd /tmp
cat > /tmp/no-prompt.conf << EOF
$nrconf{restart} = 'a';

EOF
#  sudo chown root:root no-prompt.conf
#  sudo mv -f no-prompt.conf /etc/needrestart/conf.d

fi

# Let's upgrade packages if available and install the missing needed packages.
sudo apt-get update

#Ubuntu upgrade available
NextUbuntu="$(apt-get -s upgrade | grep 'Inst base' | awk '{print $4}' | sed 's/(//')"
if [ "$NextUbuntu" = "11ubuntu5.7" ] # Only upgrade if we have tested the next release
then
  sudo apt-get -y upgrade
fi

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


# file
whichpack=$(which file)
if [ "$whichpack" = "" ]
then
  sudo apt-get -y install file
fi  

  
