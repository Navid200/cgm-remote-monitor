#!/bin/bash

echo
echo "Install packages after the installation of Nightscout. - Navid200"
echo

# Let's upgrade packages if available and install the missing needed packages.
sudo apt-get update

# packages
whichpack=$(which file)
if [ "$whichpack" = "" ]
then
  sudo apt-get -y install screen nano qrencode file gnupg
fi 

# mongo
whichpack="$(mongod --version | sed -n 1p)"
if [ ! "${whichpack%%.*}" = "db version v8" ]
then
  curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor
  echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
  sudo apt-get update
  sudo apt-get install -y mongodb-org=8.0.0 mongodb-org-database=8.0.0 mongodb-org-server=8.0.0 mongodb-mongosh mongodb-org-mongos=8.0.0 mongodb-org-tools=8.0.0
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

# The last item on the above list of packages must be verified in Status.sh to have been installed.  

# Add log
/xDrip/scripts/AddLog.sh "The secondary packages have been installed" /xDrip/Logs
  
