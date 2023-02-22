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
  clear
  dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\n\
You need to move the cursor over the filename in the right pane and press space so that it is shown in the field at the bottom. Then, press enter.\n\
Please try again." 11 50
goback=1 # Don't execute the remaining part of the loop
fi

if [ $goback -eq 0 ]
then
  if [ "$(file -b "$File" | awk '{print $2}')" = "tar" ]
  then
    if [ ! "$(tar -tf $File 'database.gz')" = "database.gz" ] || [ ! "$(tar -tf $File 'nsconfig')" = "nsconfig" ]
    then
      dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\nThe backup file may be corrupt.  Please report." 10 50
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
      clear
      if [ $fail = 1 ]
      then
        dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\nThe database import failed.  Please report." 8 50
        goback=1
      else
        dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\nThe database import is complete.  Press enter to also restore Nightscout variables from the backup.  Or, press escape not to." 10 50
        key=$?
        if [ $key = 255 ]
        then
          exit
        fi
        sudo cp -f nsconfig /etc/nsconfig
        exit
      fi
    fi  
  fi
fi

if [ $goback -eq 0 ]
then
  if [ "$(file -b "$File" | awk '{print $1}')" = "gzip" ]
  then
    mongorestore --gzip --archive=$File
    clear
    fail=$?
    if [ $fail -eq 1 ]
    then
      dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\n\
You need to move the cursor over the filename in the right pane and press space so that it is shown in the field at the bottom. Then, press enter.\n\
Please try again." 11 50
      goback=1
    else
      dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\n\Imported the backed up database." 11 50
      exit
    fi
  fi
fi
done
 
