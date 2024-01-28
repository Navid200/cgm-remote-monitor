#!/bin/bash

echo
echo "Log function" - Navid200
echo

# Requires two parameters.
# The first parameter is a line script that will be added to the log file.
# The second parameter is the full path to the log file.

if [ $# != 2 ]
then
  echo "Error: Incorrect number of parameters"
  exit 5
fi

sudo rm -rf /tmp/Logs
echo -e "$1     $(date)\n" | cat - /xDrip/Logs > /tmp/Logs
sudo /bin/cp -f /tmp/Logs $2
  
