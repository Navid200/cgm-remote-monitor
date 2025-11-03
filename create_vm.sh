#!/bin/bash
set -e
# curl https://raw.githubusercontent.com/Navid200/cgm-remote-monitor/VmInstallCloudShell_Test/create_vm.sh | bash

if [[ "$CLOUD_SHELL" != true ]]; then
  echo "You can only run this script in Cloud Shell."
  echo "Terminating"
  exit 0
fi

echo
echo "🌩️  Google Cloud Nightscout VM Installer"
echo "----------------------------------------"
echo

# --- Check for existing VMs ---
existing_vms=$(gcloud compute instances list --format="value(name)")

if [[ -n "$existing_vms" ]]; then
  echo "⚠️  Existing virtual machines found:"
  echo "$existing_vms"
  echo
  # Read directly from terminal even when piped
  read -p "Do you still want to create a new VM? (y/N): " confirm < /dev/tty
  confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')
  if [[ "$confirm" != "y" && "$confirm" != "yes" ]]; then
    echo "Aborted. No new VM was created."
    exit 0
  fi
fi

# --- Choose VM name ---
default_vm_name="nightscout-vm"
read -p "Enter a name for your new VM [${default_vm_name}]: " vm_name < /dev/tty
vm_name=${vm_name:-$default_vm_name}

regions=("us-west1" "us-central1" "us-east1")
region=${regions[$RANDOM % ${#regions[@]}]}
zone=$(gcloud compute zones list --filter="region:($region)" --format="value(name)" | shuf -n 1)

echo "Selected region: $region"
echo

echo
echo "🚀 Creating VM '${vm_name}' in zone '${zone}'..."
gcloud compute instances create gcns-2025-10-30 \
  --machine-type=e2-micro \
  --zone="$zone" \
  --image-project=ubuntu-os-cloud \
  --image-family=ubuntu-minimal-2404-lts-amd64 \
  --boot-disk-size=30GB \
  --boot-disk-type=pd-standard \
  --network-tier=STANDARD \
  --tags=http-server,https-server \
  --no-shielded-secure-boot \
  --maintenance-policy=MIGRATE \
  --provisioning-model=STANDARD \
  --no-enable-display-device
  
  
