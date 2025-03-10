#!/bin/bash

echo
echo "Verifying install completion"
echo

count=0
apt_present=1
while [ $apt_present -gt 0 ]
do

ps aux | grep '[a]pt' > /tmp/running_apt
if [ -s /tmp/running_apt ]
then
  echo " $count  Waiting for installation to complete"
  sleep 10
  count = count + 10
else
  apr_present=0
fi

done
