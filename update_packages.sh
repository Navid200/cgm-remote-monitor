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
if [ "$NextUbuntu" = "13ubuntu10.4" ] # Only upgrade if we have tested the next release (24.04.4)
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

# Check for version 7.0.14 (a stable 7.0 release)
if [ -z "$mongover" ] || dpkg --compare-versions "$mongover" lt "7.0.14"
then
  /xDrip/scripts/wait_4_completion.sh

  # Use the 7.0 GPG key
  if [ ! -f /usr/share/keyrings/mongodb-server-7.0.gpg ]; then
    curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg
  fi

  # Use the jammy repository for version 7.0 (noble does not have a native 7.0 repo)
  echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
  
  /xDrip/scripts/wait_4_completion.sh
  sudo apt-get update

  # allow upgrade/downgrade if packages were previously held
  sudo apt-mark unhold mongodb-org mongodb-org-database mongodb-org-server mongodb-mongosh mongodb-org-mongos mongodb-org-tools || true

  # Install specific 7.0.14 versions
  sudo apt-get install -y mongodb-org=7.0.14 mongodb-org-database=7.0.14 mongodb-org-server=7.0.14 mongodb-mongosh mongodb-org-mongos=7.0.14 mongodb-org-tools=7.0.14

  # re-hold to prevent unintended upgrades
  sudo apt-mark hold mongodb-org mongodb-org-database mongodb-org-server mongodb-mongosh mongodb-org-mongos mongodb-org-tools

  /xDrip/scripts/wait_4_completion.sh
  sudo systemctl enable mongod
  sudo systemctl start mongod
fi



# node - Install Node 22.22.0
NODE_VERSION="22.22.0"
NODE_URL="https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz"
NODE_INSTALL_DIR="/usr/local/node-$NODE_VERSION"

get_installed_node_version() {
    node -v 2>/dev/null
}

is_correct_node_version() {
    echo "$1" | grep -q "^v$NODE_VERSION$"
}

install_node() {
    version=$(get_installed_node_version)
    if is_correct_node_version "$version"; then
        echo "Node $NODE_VERSION is already installed, skipping."
        return
    fi

    echo "Installing Node $NODE_VERSION..."
    sudo rm -rf "$NODE_INSTALL_DIR"
    curl -fsSL "$NODE_URL" -o "/tmp/node-v$NODE_VERSION.tar.xz"
    sudo mkdir -p "$NODE_INSTALL_DIR"
    sudo tar -xf "/tmp/node-v$NODE_VERSION.tar.xz" -C "$NODE_INSTALL_DIR" --strip-components=1
    rm "/tmp/node-v$NODE_VERSION.tar.xz"

    export PATH="$NODE_INSTALL_DIR/bin:$PATH"
    sudo ln -sf "$NODE_INSTALL_DIR/bin/node" /usr/local/bin/node
    sudo ln -sf "$NODE_INSTALL_DIR/bin/npm" /usr/local/bin/npm
    sudo ln -sf "$NODE_INSTALL_DIR/bin/npx" /usr/local/bin/npx

    # Log after successful installation
    /xDrip/scripts/AddLog.sh "Node $NODE_VERSION installed successfully" /xDrip/Logs
}

whichpack=$(get_installed_node_version)
if [ -z "$whichpack" ] || ! is_correct_node_version "$whichpack"; then
    /xDrip/scripts/wait_4_completion.sh
    install_node
fi
  
