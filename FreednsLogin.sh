#!/bin/bash

echo
echo "Log into the FreeDNS site in the background. - Navid200"
echo

freedns=$(wget --spider -S "https://freedns.afraid.org/" 2>&1 | awk '/HTTP\// {print $2}') # This will be 200 if FreeDNS is up.
if [ $freedns -eq 200 ]  # Run the following only if FreeDNS is up.
then
  # This could also run in the background.  So, it should contain no dialog.  
  if [ -s /xDrip/FreeDNS_ID_Pass ] # If the FreeDNS_ID_Pass file exists
  then
    . /xDrip/FreeDNS_ID_Pass
    user=$User_ID
    pass=$Password
    # Add log
    rm -rf /tmp/Logs
    echo -e "Logged into FreeDNS.      $(date)\n" | cat - /xDrip/FreeDNS_AutoLogin_Logs > /tmp/Logs
    sudo /bin/cp -f /tmp/Logs /xDrip/FreeDNS_AutoLogin_Logs
  fi
fi
 
