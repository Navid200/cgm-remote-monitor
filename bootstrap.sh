#!/bin/bash
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"

echo 
echo "Bootstrapping the installation files - Navid200"
echo

if [ ! -z "$(ls /srv)" ]
then
dialog --colors --msgbox "     \Zr Developed by the xDrip team \Zn\n\n\
The script you are running \"bootstrap\", is meant to initiate an installtion.  \
However, the file system does not seem to be empty.  If you already have an installtion on this machine and \
proceed bypressing enter, you will be modifying it.  If that's not your intention, please press escape to interrupt." 13 50
if [ $? eq 255 ]
then
exit
fi
fi

sudo apt-get update
sudo apt-get install dialog
ubversion="$(cat /etc/issue | awk '{print $2}')"
if [[ ! "$ubversion" = "20.04"* ]]
then
clear
dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\n\
The Ubuntu version on the virtual machine is incorrect.  You need to delete the virtual machine and create a new one.  Please refer to the guide for the details." 10 50
exit
fi

sudo apt-get -y install wget bash
sudo apt-get install -y  git python gcc g++ make
sudo apt-get -y install netcat

cd /
if [ ! -s xDrip ] # Create the xDrip directory if it does not exist.
then
sudo mkdir xDrip
fi
cd xDrip
if [ ! -s scripts ]
then
sudo mkdir scripts
fi

# Let's create a directory for cloning from the fork we are installing from.
sudo -rf rm clone # Delete a previous directory if one exists. 
sudo mkdir clone
cd clone

sudo git clone https://github.com/jamorham/nightscout-vps.git  # MAINMAINMAINMAINMAINMAINMAINMAINMAINMAIN # Uncomment before PR.
#sudo git clone https://    # TESTTESTTESTTESTTESTTESTTESTTESTTESTTEST # Comment out before PR.

ls > /tmp/repo
sudo mv -f /tmp/repo .    # The repository name is now in /xDrip/clone/repo
cd "$(< repo)"

sudo git checkout vps-1  # MAINMAINMAINMAINMAINMAINMAINMAINMAINMAIN # Uncomment before PR.
#sudo git checkout     # TESTTESTTESTTESTTESTTESTTESTTESTTESTTEST # Comment out before PR.

sudo git branch > /tmp/branch
grep "*" /tmp/branch | awk '{print $2}' > /tmp/brnch
sudo mv -f /tmp/brnch ../.  # The branch name is now in /xDrip/clone/brnch
cd ..

if [ ! -s update_scripts.sh ]
then
echo "UNABLE TO DOWNLOAD update_scripts SCRIPT! - cannot continue - please try again!"
exit 5
fi

sudo chmod 755 *.sh
sudo cp -f update_scripts.sh /xDrip/scripts

# Updating the scripts
cat > /tmp/nodialog_update_scripts << EOF
Don't show dialog

EOF

/xDrip/scripts/update_scripts.sh

# So that the menu comes up as soon as the user logs in (opens a terminal)
cd /tmp
cat > /tmp/start_menu.sh << EOF
#!/bin/sh
sleep 1
/xDrip/scripts/menu.sh

EOF
sudo chown root:root start_menu.sh
sudo chmod 755 start_menu.sh
sudo mv -f start_menu.sh /etc/profile.d

if [ "$(grep /xDrip/scripts/menu.sh ~/.bash_aliases)" = "" ] # If there is no alias to menu.sh not even commented out
then
cat >> ~/.bash_aliases << EOF
alias menu="/xDrip/scripts/menu.sh"
EOF
fi

clear
dialog --colors --msgbox "     \Zr Developed by the xDrip team \Zn\n\n\
If any item is shown in red on the status page (shown next), it represents an incorrect parameter that could result in malfunction or cost.  \
Please take a note, delete the virtual machine, and create a new one.   For more detail, please refer to the guide." 12 50

# Bring up the status page
/xDrip/scripts/Status.sh
clear
/xDrip/scripts/menu.sh < /dev/tty
 
