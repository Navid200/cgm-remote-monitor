#!/bin/bash

echo
echo "Verifying install completion"
echo

count=0
apt_present=1
while [ $apt_present -gt 0 ]
do

running_apt=$(ps aux | grep '[a]pt') 
if [ "$running_apt" = "" ]
then
  apr_present=0
else
  echo " $count  Waiting for installation to complete"
  sleep 10
  count = count + 10
fi

done
