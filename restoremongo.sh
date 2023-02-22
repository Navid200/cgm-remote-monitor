#!/bin/bash

while :
do
File=$(dialog --title "Select the backup file to restore" --fselect ~/ 10 50 3>&1 1>&2 2>&3)

key=$?

if [ $key = 255 ] || [ $key = 1 ]
then
clear
exit
fi

echo "$File"
if [ "$(file -b "$File" | awk '{print $2}')" = "tar" ]
then
  if [ ! "$(tar -tf $File 'database.gz')" = "database.gz" ] || [ ! "$(tar -tf $File 'nsconfig')" = "nsconfig" ]
  then
    dialog --msgbox "Error\n The backup file may be corrupt.  Please report." 10 50
    exit
  fi
  rm -f /tmp/nsconfig
  rm -f /tmp/database.gz
  tar -xf $File -C /tmp/.
  cd /tmp
  mongorestore --gzip --archive=database.gz
  fail=$?
  if [ $fail = 1 ]
  then
    dialog --msgbox "Error\n The backup file may be corrupted.  Please report." 10 50
  else
    
  fi
fi

mongorestore --gzip --archive=$File
fail=$?
if [ $fail = 1 ]
then
dialog --msgbox "Error\n\
You need to move the cursor over the filename\n\
in the right pane and press space so that it\n\
is shown in the field at the bottom.\n\
Then, move the cursor over OK and press enter." 10 50
else
clear
# Add log
rm -rf /tmp/Logs
echo -e "Mongo restore     $(date)\n" | cat - /xDrip/Logs > /tmp/Logs
sudo /bin/cp -f /tmp/Logs /xDrip/Logs
exit
fi

done
 
