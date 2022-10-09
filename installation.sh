#!/bin/bash

echo
echo "JamOrHam Nightscout Installer - Designed for Google Compute Minimal Ubuntu 20 micro instance"
echo


if [ "`id -u`" != "0" ]
then
echo "Script needs root - execute bootstrap.sh or use sudo bash installation.sh"
echo "Cannot continue.."
exit 5
fi

if [ ! -s /var/SWAP ]
then
echo "Creating swap file"
dd if=/dev/zero of=/var/SWAP bs=1M count=2000
chmod 600 /var/SWAP
mkswap /var/SWAP
fi
swapon 2>/dev/null /var/SWAP

echo "Installing dialog"
sudo apt-get update
sudo apt-get -y install dialog

clear #  Clear the screen before placing the next dialog on.
dialog --yesno "Install system basics?\n\n
Choose Yes to install Linux executables.  You need to if you have never done it on this virtual machine.\n\n
Choose No to skip if you have done this already on this virtual machine.\n\n
Or, press escape to cancel." 14 50
ans=$?
if [ $ans = 255 ] # Exit if escape is pressed.
then
clear # Clear the screen before exiting.
exit 5
elif [ $ans = 0 ] # Install
then
sudo apt-get -y install wget gnupg libcurl4 openssl liblzma5
sudo apt-get -y install dirmngr apt-transport-https lsb-release ca-certificates
sudo apt-get -y install vis
sudo apt-get -y install nano
sudo apt-get -y install screen
sudo apt-get -y install net-tools
sudo apt-get -y install build-essential
sudo apt-get -y install mongodb-server
sudo apt-get -y install jq
fi
clear  # Clear the last dialog

echo -e "use Nightscout\ndb.createUser({user: \"username\", pwd: \"password\", roles:[\"readWrite\"]})\nquit()" | mongo

sudo apt-get install -y  git python gcc g++ make

echo "Installing Node js"

sudo apt-get install -y nodejs npm
sudo apt -y autoremove

cd /srv
echo "Installing Nightscout"
# Setting the defaults
user="nightscout"
repo="cgm-remote-monitor"
brnch="master"

clear #  Clear the screen before placing the next dialog on.
dialog --yesno "You can reeinstall Nightscout.\n\n
Choose Yes to install the latest version of official Nightscout.\n\n
Choose No to install from a fork you can specify (advanced).\n\n
Or, press escape to cancel." 14 50
ans=$?
if [ $ans = 255 ] # Exit if escape is pressed.
then
clear # Clear the screen before exiting.
exit 5
elif [ $ans = 1 ] # We need Github details
then
# So, let's clear these first.
user=""
repo=""
brnch=""

# open fd
exec 3>&1

# Now, let's ask for the details of the fork
# Store data to $VALUES variable
clear # Clear the screen before placing the next dialog on.
VALUES=$(dialog --ok-label "Submit" --form "Enter the GitHub details for the Nightscout version you want to install.\n" 12 50 0 "User ID:" 1 1 "$user" 1 14 25 0 "Repository:" 2 1 "$repo" 2 14 25 0 "Branch:" 3 1 "$brnch" 3 14 25 0 2>&1 1>&3)
ans2=$?
if [ $ans2 = 255 ] || [ $ans2 = 1 ] # Exit if escaped or cancelled
then
clear # Clear the screen before existing.
exit 5
fi

# close fd
exec 3>&-

# display values just entered
#echo "$VALUES"
user=$(echo "$VALUES" | sed -n 1p)
repo=$(echo "$VALUES" | sed -n 2p)
brnch=$(echo "$VALUES" | sed -n 3p)
fi
clear  # Clear the last dialog

if [ -s ./$repo ] # Delete the repository directory if it exists.
then
sudo rm -r $repo
fi

combined="https://github.com/$user/$repo.git" # This is the path to the repository we are installing from
sudo git clone $combined

# Kill Nightscout
sudo pkill -f SCREEN
cd $repo
sudo git checkout $brnch
sudo git pull

sudo npm install
sudo npm run postinstall
sudo npm run generate-keys

for loop in 1 2 3 4 5 6 7 8 9
do
read -t 0.1 dummy
done

if [ ! -s /usr/local/etc/no-ip2.conf ]
then
cd /usr/src
sudo tar -xzf /srv/nightscout-vps/helper/noip-duc-linux.tar.gz
cd /usr/src/noip-2.1.9-1
sudo make install
else
echo "Noip client already installed - delete /usr/local/etc/no-ip2.conf if you want to change config"
fi
noip2 -S

hostname=`noip2 -S 2>&1 | grep host | tr -s ' ' | tr -d '\t' | cut -f2 -d' ' | head -1`

if [ "$hostname" = "" ]
then
echo "Could not determine host name - did no ip dynamic dns install fail?"
echo "Cannot continue!"
exit 5
fi

# execute installer
noip2

sudo apt-get install -y nginx python3-certbot-nginx inetutils-ping

if [ "`grep '.well-known' /etc/nginx/sites-enabled/default`" = "" ]
then
sudo rm -f /tmp/nginx.conf
sudo grep -v '^#' /etc/nginx/sites-enabled/default >/tmp/nginx.conf

cat /tmp/nginx.conf | sed -z -e 'sZlocation / {[^}]*}Zlocation /.well-known {\n        try_files $uri $uri/ =404;\n}\n\nlocation / {\nproxy_pass  http://127.0.0.1:1337/;\nproxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\nproxy_set_header X-Forwarded-Proto https;\nproxy_http_version 1.1;\nproxy_set_header Upgrade $http_upgrade;\nproxy_set_header Connection "upgrade";\n}Zg' >/etc/nginx/sites-enabled/default

sudo service nginx stop

else
echo "Nginx config already patched"
fi

sudo service nginx start
sudo certbot --nginx -d "$hostname"

sudo systemctl daemon-reload
sudo systemctl start mongodb

clear #  Clear the screen before placing the next dialog on.
dialog --yesno "Reset Nightscout variables?\n\n
Choose Yes to set Nightscout variables to default.  You need to if you have never done it on this virtual machine.\n\n
Choose No to skip if you have done this already on this virtual machine.\n\n
Or, press escape to cancel." 14 50
ans=$?
if [ $ans = 255 ] # Exit if escape is pressed.
then
clear # Clear the screen before exiting.
exit 5
elif [ $ans = 0 ] # Reset
then
cat > /etc/nsconfig << EOF
export API_SECRET="YOUR_API_SECRET_HERE"
export ENABLE="careportal food boluscalc bwp cob bgi pump openaps rawbg iob upbat cage sage basal"
export AUTH_DEFAULT_ROLES="denied"
export PUMP_FIELDS="reservoir battery clock"
export DEVICESTATUS_ADVANCED="true"
EOF

cs=`grep 'API_SECRET=' /etc/nsconfig | head -1 | cut -f2 -d'"'`
echo "Current API secret is: $cs"
echo
echo "If you would like to change it please enter the new secret now or hit enter to leave the same"


read -p "New secret 12 character minimum length (blank to skip change) : " ns

if [ "$ns" != "" ]
then
while [ ${#ns} -lt 12 ] && [ "$ns" != "" ]
do
read -p "Needs to be at least 12 chars - try again: " ns
done
if [ "$ns" != "" ]
then
sed -i -e "s/API_SECRET=\".*/API_SECRET=\"${ns}\"/g" /etc/nsconfig
echo
echo "Secret changed to: ${ns}"
sleep 3
fi
fi

fi
clear  # Clear the last dialog

echo
echo "Setting up startup service"
echo

cat> /etc/nightscout-start.sh<<EOF

#!/bin/sh
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
. /etc/nsconfig
export MONGO_COLLECTION="entries"
export MONGO_CONNECTION="mongodb://username:password@localhost:27017/Nightscout"
export INSECURE_USE_HTTP=true
export HOSTNAME="127.0.0.1"
export PORT="1337"
cd /srv/$repo
EOF

cat>> /etc/nightscout-start.sh<< "EOF"

while [ "`netstat -lnt | grep 27017 | grep -v grep`" = "" ]
do
echo "Waiting for mongo to start"
sleep 5
done
sleep 5
while [ 1 ]
do
node server.js
sleep 30
done
EOF

# rc.local
cat > /etc/rc.local << "EOF"
#!/bin/bash
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
cd /tmp
swapon /var/SWAP
service snapd stop
/usr/local/bin/noip2 &
service mongodb start
screen -dmS nightscout sudo -u nobody bash /etc/nightscout-start.sh
service nginx start
EOF

chmod a+x /etc/rc.local

cat > /etc/systemd/system/rc-local.service << "EOF"
[Unit]
 Description=/etc/rc.local Compatibility
 ConditionPathExists=/etc/rc.local
[Service]
 Type=forking
 ExecStart=/etc/rc.local start
 TimeoutSec=0
 StandardOutput=tty
 RemainAfterExit=yes
[Install]
 WantedBy=multi-user.target
EOF
sudo sed -i -e 'sX//Unattended-Upgrade::Automatic-Reboot "false";XUnattended-Upgrade::Automatic-Reboot "true";Xg' /etc/apt/apt.conf.d/50unattended-upgrades 
sudo systemctl daemon-reload
sudo systemctl enable rc-local




