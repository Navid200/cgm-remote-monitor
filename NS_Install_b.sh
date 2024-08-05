#!/bin/bash

echo
echo "JamOrHam Nightscout Installer - Designed for Google Compute Minimal Ubuntu 20 micro instance"
echo


# Create mongo user and admin.
echo -e "use Nightscout\ndb.createUser({user: \"username\", pwd: \"password\", roles:[\"readWrite\"]})\nquit()" | mongosh
echo -e "use admin\ndb.createUser({ user: \"mongoadmin\" , pwd: \"mongoadmin\", roles: [\"userAdminAnyDatabase\", \"dbAdminAnyDatabase\", \"readWriteAnyDatabase\"]})\nquit()" | mongosh


  
