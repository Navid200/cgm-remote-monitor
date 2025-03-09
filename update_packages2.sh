#!/bin/bash

echo
echo "Install packages after the installation of Nightscout. - Navid200"
echo

# List of packages installed here:
# screen  nano  qrencode  file  vis  lsb-release  apt-transport-https  ca-certificates  python3-pip  python3-django  python3-django-extensions  python3-werkzeug  python3-qrcode

# Let's upgrade packages if available and install the missing needed packages.
sudo apt-get -o DPkg::Lock::Timeout=30 update

# packages
whichpack=$(which file)
if [ "$whichpack" = "" ]
then
  sudo apt-get -o DPkg::Lock::Timeout=30 -y install screen nano qrencode file vis lsb-release apt-transport-https ca-certificates 
  sudo apt-get -o DPkg::Lock::Timeout=30 -y install python3-pip
  sudo apt -y install python3-django python3-django-extensions python3-werkzeug python3-qrcode
fi 

# The last item on the above list of packages must be verified in Status.sh to have been installed.  

# Add log
/xDrip/scripts/AddLog.sh "The secondary packages have been installed" /xDrip/Logs

  
