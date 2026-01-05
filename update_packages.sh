#!/bin/bash

echo
echo "Install packages. - Navid200"
echo

# Reduce the number of snapshots kept from the default 3 to 2 to reduce disk space usage.
sudo snap set system refresh.retain=2

# Let's upgrade packages if available and install the missing needed packages.
/xDrip/scripts/wait_4_completion.sh
sudo apt-get update

#Ubuntu upgrade available
NextUbuntu="$(apt-get -s upgrade | grep 'Inst base' | awk '{print $4}' | sed 's/(//')"
if [ "$NextUbuntu" = "13ubuntu10.3" ] # Only upgrade if we have tested the next release (24.04.3)
then
  sudo apt-get -y upgrade
fi

# packages
whichpack=$(which gpg)
if [ "$whichpack" = "" ]
then
  /xDrip/scripts/wait_4_completion.sh
  sudo apt-get -y install jq net-tools gnupg
  # The last item on the above list of packages must be verified in Status.sh to have been installed.
fi 


# mongo
mongover="$(mongod --version 2>/dev/null | sed -n 's/^db version v//p' | head -n1)"

if [ -z "$mongover" ] || dpkg --compare-versions "$mongover" lt "8.0.17"
then
  /xDrip/scripts/wait_4_completion.sh

  curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor

  echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
  /xDrip/scripts/wait_4_completion.sh
  sudo apt-get update

  # allow upgrade if packages were previously held
  sudo apt-mark unhold mongodb-org mongodb-org-database mongodb-org-server mongodb-mongosh mongodb-org-mongos mongodb-org-tools || true

  sudo apt-get install -y mongodb-org=8.0.17 mongodb-org-database=8.0.17 mongodb-org-server=8.0.17 mongodb-mongosh mongodb-org-mongos=8.0.17 mongodb-org-tools=8.0.17

  # re-hold to prevent unintended upgrades
  sudo apt-mark hold mongodb-org mongodb-org-database mongodb-org-server mongodb-mongosh mongodb-org-mongos mongodb-org-tools

  /xDrip/scripts/wait_4_completion.sh
  systemctl enable mongod
  systemctl start mongod
fi


# node - We install version 16 of node here, which automatically  updates npm to 8.
check_node_candidate() {
  apt-cache policy nodejs | grep Candidate | awk '{print $2}'
}

# Function to test if candidate starts with 16
is_node16() {
  echo "$1" | grep -q '^16\.'
}

install_node16() {
  candidate=$(check_node_candidate)
  if is_node16 "$candidate"; then
    echo "Confirmed: Node candidate is $candidate, proceeding with install."
    sudo apt-get install -y nodejs
    # Nightscout needs version 6 of npm.  So, we are going to install that version now effectivwely downgrading it.
    sudo npm install -g npm@6.14.18
    /xDrip/scripts/AddLog.sh "The packages have been installed" /xDrip/Logs
  else
    echo "ERROR: Node candidate is $candidate, not v16. Aborting."
    /xDrip/scripts/AddLog.sh "The packages except Node have been installed" /xDrip/Logs
    clear
    dialog --colors --infobox "         \Zr Google Cloud Nightscout \Zn\n\n\n\
Node 16 install has failed.\n\
Please run Phase 1 again.\n\n\
Press any key to return to the main menu." 9 50
    read -p "" -n1 -s </dev/tty
    exit 99   # special exit code so callers know it failed
  fi
}

whichpack=$(node -v)

if [ -z "$whichpack" ] || [ "${whichpack%%.*}" != "v16" ]; then
  /xDrip/scripts/wait_4_completion.sh
  sudo /xDrip/scripts/nodesource_setup.sh
  /xDrip/scripts/wait_4_completion.sh
  install_node16
fi
  
