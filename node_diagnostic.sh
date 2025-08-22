#!/bin/bash
echo
echo "=== NodeSource / Node.js Diagnostic Script ==="
echo

# Node version
echo "1️⃣ Node version installed:"
node -v 2>/dev/null || echo "Node is not installed"

# NPM version
echo
echo "2️⃣ NPM version installed:"
npm -v 2>/dev/null || echo "NPM is not installed"

# Check NodeSource repo file
echo
echo "3️⃣ NodeSource repo file (/etc/apt/sources.list.d/nodesource.list):"
if [ -f /etc/apt/sources.list.d/nodesource.list ]; then
    cat /etc/apt/sources.list.d/nodesource.list
else
    echo "❌ NodeSource repo file not found"
fi

# Check NodeSource GPG key
echo
echo "4️⃣ NodeSource GPG key (/usr/share/keyrings/nodesource.gpg):"
if [ -f /usr/share/keyrings/nodesource.gpg ]; then
    echo "✅ File exists"
else
    echo "❌ GPG key file not found"
fi

# Check which repo apt will use for nodejs
echo
echo "5️⃣ Apt policy for nodejs:"
apt-cache policy nodejs || echo "Cannot get apt-cache policy"

# Check Ubuntu version
echo
echo "6️⃣ Ubuntu version:"
lsb_release -a 2>/dev/null || cat /etc/os-release

# Check architecture
echo
echo "7️⃣ System architecture:"
dpkg --print-architecture

echo
echo "✅ Diagnostic complete."
echo "Please send this output if Node 16 is not installed as expected."
