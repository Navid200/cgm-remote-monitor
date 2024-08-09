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
cat > /tmp/no-prompt.conf << "EOF"
$nrconf{restart} = 'a';

EOF
  sudo mv -f no-prompt.conf /etc/needrestart/conf.d
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
whichpack=$(which net-tools)
if [ "$whichpack" = "" ]
then
  sudo apt-get -y install vis nano screen jq qrencode file net-tools
fi

# mongo
whichpack="$(mongod --version | sed -n 1p)"
if [ ! "${whichpack%%.*}" = "db version v6" ]
then
 curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor
 echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
 sudo apt-get update
 sudo apt-get install -y mongodb-org=6.0.16 mongodb-org-database=6.0.16 mongodb-org-server=6.0.16 mongodb-org-mongos=6.0.16 mongodb-org-tools=6.0.16

 echo "mongodb-org hold" | sudo dpkg --set-selections
 echo "mongodb-org-database hold" | sudo dpkg --set-selections
 echo "mongodb-org-server hold" | sudo dpkg --set-selections
 echo "mongodb-mongosh hold" | sudo dpkg --set-selections
 echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
 echo "mongodb-org-tools hold" | sudo dpkg --set-selections

  sudo systemctl start mongod
  # sudo systemctl status mongod
  sudo systemctl enable mongod
fi
  
