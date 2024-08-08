#!/bin/bash

echo
echo "Install packages only if they are not installed already. - Navid200"
echo

# Please keep in mind that what you add here is run during a fresh installation as well as during an update.
# Therefore, you must only install if it is not installed already to avoid wasting time.  

# Reduce the number of snapshots kept from the default 3 to 2 to reduce disk space usage.
sudo snap set system refresh.retain=2

# Let's upgrade packages if available and install the missing needed packages.
sudo apt-get update


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

# node - We install version 16 of node here, which automatically  updates npm to 8.
whichpack=$(node -v)
if [ ! "${whichpack%%.*}" = "v16" ]
then
sudo /xDrip/scripts/nodesource_setup.sh
# sudo apt install -y nodejs
sudo apt-get install nodejs -y
fi 

# Nightscout needs version 6 of npm.  So, we are going to install that version now effectivwely downgrading it.  
sudo npm install -g npm@6.14.18
  

# The last item on the above list of packages must be verified in Status.sh to have been installed.  

# Add log
/xDrip/scripts/AddLog.sh "The packages have been updated" /xDrip/Logs
  
