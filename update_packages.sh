#!/bin/bash

echo
echo "Install packages. - Navid200"
echo

# Reduce the number of snapshots kept from the default 3 to 2 to reduce disk space usage.
sudo snap set system refresh.retain=2

# Let's upgrade packages if available and install the missing needed packages.
sudo apt-get update

#Ubuntu upgrade available
#NextUbuntu="$(apt-get -s upgrade | grep 'Inst base' | awk '{print $4}' | sed 's/(//')"
#if [ "$NextUbuntu" = "11ubuntu5.8" ] # Only upgrade if we have tested the next release
#then
#  sudo apt-get -y upgrade
#fi

# packages
whichpack=$(which file)
if [ "$whichpack" = "" ]
then
  sudo apt-get -y install vis nano screen jq qrencode file net-tools gnupg liblzma5 apt-transport-https lsb-release ca-certificates nginx python3-certbot-nginx inetutils-ping
fi

# mongo
whichpack="$(mongod --version | sed -n 1p)"
if [ ! "$whichpack" = "db version v6.0.16" ]
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
  sudo systemctl enable mongod

  # Create mongo user and admin.
  echo -e "use Nightscout\ndb.createUser({user: \"username\", pwd: \"password\", roles:[\"readWrite\"]})\nquit()" | mongosh
  echo -e "use admin\ndb.createUser({ user: \"mongoadmin\" , pwd: \"mongoadmin\", roles: [\"userAdminAnyDatabase\", \"dbAdminAnyDatabase\", \"readWriteAnyDatabase\"]})\nquit()" | mongosh
fi


whichpack="$(mongod --version | sed -n 1p)"
if [ ! "${whichpack%%.*}" = "db version v3" ]
then
  
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

# The last item on the above list of packages must be verified in Status.sh to have been installed.  

# Add log
/xDrip/scripts/AddLog.sh "The packages have been installed" /xDrip/Logs
  
