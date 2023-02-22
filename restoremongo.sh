#!/bin/bash

while :
do
goback=0 # Reset the loop
File=$(dialog --title "Select the backup file to restore" --fselect ~/ 10 50 3>&1 1>&2 2>&3)
key=$?

if [ $key = 255 ] || [ $key = 1 ]
then
exit
fi

echo "$File"

if [ "$(file -b "$File")" = "directory" ]
then
  dialog --msgbox "Error\n\
You need to move the cursor over the filename\n\
in the right pane and press space so that it\n\
is shown in the field at the bottom.\n\
Then, move the cursor over OK and press enter." 10 50
goback=1 # Don't execute the remaining part of the loop
fi

if [ $goback -eq 0 ]
then
  if [ "$(file -b "$File" | awk '{print $2}')" = "tar" ]
  then
    if [ ! "$(tar -tf $File 'database.gz')" = "database.gz" ] || [ ! "$(tar -tf $File 'nsconfig')" = "nsconfig" ]
    then
      dialog --msgbox "Error\n The backup file may be corrupt.  Please report." 10 50
      goback=1 # Don't execute the rest of the loop
    fi
    if [ $goback -eq 0 ]
    then
      rm -f /tmp/nsconfig
      rm -f /tmp/database.gz
      tar -xf $File -C /tmp/.
      cd /tmp
      mongorestore --gzip --archive=database.gz
      fail=$?
      if [ $fail = 1 ]
      then
        dialog --msgbox "Error\n The database restore failed.  Please report." 10 50
        goback=1
      else
        echo "nsconfig restore"
      fi
    fi  
  fi
fi
done
 
