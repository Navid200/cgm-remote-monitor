#!/bin/bash

echo
echo "Verifying install completion"
echo

ps aux | grep '[a]pt' > /tmp/running_apt
if [ -s /tmp/running_apt ]
then
  echo "apt is running"
fi
