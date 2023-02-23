#!/bin/bash

while :
do
goback=0 # Reset the loop
File=$(dialog --title "Select the backup file for restore" --fselect ~/ 10 50 3>&1 1>&2 2>&3)
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
      clear
      Choice=$(dialog --colors --nocancel --nook --menu "\
        \Zr Developed by the xDrip team \Zn\n\n\
Use the arrow keys to move the cursor.\n\
Press Enter to execute the highlighted option.\n" 14 50 3\
      "1" "Restore MongoDB only"\
      "2" "Restore variables only"\
      "3" "Restore MongoDB and variables"\
      3>&1 1>&2 2>&3)
      
      case $Choice in
      
      db=0
      var=0;
      1)
      db=1
      ;;
      
      2)
      var=1
      ;;
      
      3)
      db=1
      var=1
      ;;
      
      esac
      
      if [ $db -eq 1 ]
      then
        mongorestore --gzip --archive=database.gz
        fail=$?
        if [ $fail = 1 ]
        then
          dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\nThe database import failed.  Please report." 8 50
        fi
      fi
      
      if [ var -eq 1 ]
      then
        sudo cp -f nsconfig /etc/nsconfig
        dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\nThe variables have been restored from backup.  You need to restart the server for the updated variables to take effect." 10 50
      fi
      exit
    fi  
  fi
fi

if [ $goback -eq 0 ]
then
  if [ "$(file -b "$File" | awk '{print $1}')" = "gzip" ]
  then
    dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\n\
The backup only contains the database.  Press enter to restore it." 11 50
    key=$?
    if [ $key = 255 ]
    then
      exit
    fi
    mongorestore --gzip --archive=$File
    clear
    fail=$?
    if [ $fail -eq 1 ]
    then
      dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\nThe database import failed.  Please report." 11 50
      exit
    else
      dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\nImported the backed up database." 8 50
      exit
    fi
  fi
fi
done
 
