#!/bin/bash

echo
echo "Record FreeDNS user ID and password in /xDrip/FreeDNS_ID_Pass - Navid200"
echo

# If the FreeDNS password has been changed since installation, this script can be used to update it in our setup for auto-login.
# If this system was created before we added auto-login, this script can be used to add user ID and password to our setup for auto login.

freedns=$(wget --spider -S "https://freedns.afraid.org/" 2>&1 | awk '/HTTP\// {print $2}') # This will be 200 if FreeDNS is up.

if [ $freedns -eq 200 ]  # Run the following only if FreeDNS is up.
then
echo "FreeDNS is up"
  exec 3>&1
  Values=$(dialog --colors --ok-label "Submit" --form "       \Zr Developed by the xDrip team \Zn\n\n\n\
This is only to enter the user ID and password in Google Cloud Nightscout.  If you want to change your user ID or password, you will need to log into FreeDNS to do that.\n\n\
Enter your ID and password to proceed.  Or press escape to cancel." 20 50 0 "User ID:" 1 1 "$user" 1 14 25 0 "Password:" 2 1 "$pass" 2 14 25 0 2>&1 1>&3)
  response=$?
  if [ $response = 255 ] || [ $response = 1 ] # cancled or escaped
  then
  echo "Cancelled"
    exit 5
  fi
  exec 3>&-
  user=$(echo "$Values" | sed -n 1p)
  pass=$(echo "$Values" | sed -n 2p)
  cat > /xDrip/FreeDNS_ID_Pass << EOF
#!/bin/sh
# This file is generated automatically.  It will be deleted and recreated.
# Please do not add anything to this file.
export User_ID=$user
export Password=$pass
EOF

else # If FreeDNS is down
echo "FreeDNS is down"
  dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\n\
It seems the FreeDNS site is down.  Please try again when FreeDNS is back up." 9 50
  cat > /tmp/FreeDNS_Failed << EOF
The FreeDNS site is down.
EOF

fi
