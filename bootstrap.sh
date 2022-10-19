#!/bin/sh
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"

echo 
echo "Bootstrapping the menu - JamOrHam"
echo

sudo apt-get update
sudo apt-get -y install wget bash
sudo apt-get -y install dialog
sudo apt-get install -y  git python gcc g++ make

cd /
if [ ! -s xDrip ]
then
sudo mkdir xDrip
fi
cd xDrip
if [ ! -s scripts ]
then
sudo mkdir scripts
fi
cd /tmp
if [ ! -s update_scripts.sh ]
then
wget https://raw.githubusercontent.com/Navid200/cgm-remote-monitor/Navid_2022_10_14c/update_scripts.sh # Navid's
#wget https://raw.githubusercontent.com/jamorham/nightscout-vps/vps-1/update_scripts.sh # Main
if [ ! -s update_scripts.sh ]
then
echo "UNABLE TO DOWNLOAD update_scripts SCRIPT! - cannot continue - please try again!"
exit 5
fi
fi

sudo chmod 755 update_scripts.sh
sudo mv -f update_scripts.sh /xDrip/scripts

# Updating the scripts
sudo /xDrip/scripts/update_scripts.sh

# So that the menu comes up as soon as the user logs in (opens a terminal)
cd /tmp
cat > start_menu.sh << EOF
#!/bin/sh
/xDrip/scripts/menu.sh

EOF
sudo chown root:root start_menu.sh
sudo chmod 755 start_menu.sh
sudo mv -f start_menu.sh /etc/profile.d

cat > ~/.bash_aliases << EOF
alias menu="/xDrip/scripts/menu.sh"

EOF

# Reboot
sudo reboot
