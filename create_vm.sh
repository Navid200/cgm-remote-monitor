#!/bin/bash
set -e
# curl https://raw.githubusercontent.com/jamorham/nightscout-vps/vps-2/create_vm.sh | bash

if [[ "$CLOUD_SHELL" != true ]]; then
  echo "You can only run this script in Cloud Shell."
  echo "Terminating."
  exit 0
fi

echo
echo "🌩️  Google Cloud Nightscout VM Installer"
echo "----------------------------------------"
echo "✅ Environment: Cloud Shell confirmed"
echo

# --- Check for existing VMs ---
existing_vms=$(gcloud compute instances list --format="value(name)")

if [[ -n "$existing_vms" ]]; then
  echo "⚠️  Existing virtual machines found:"
  echo "$existing_vms"
  echo
  read -p "Do you still want to create a new VM? (y/N): " confirm < /dev/tty
  confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')
  if [[ "$confirm" != "y" && "$confirm" != "yes" ]]; then
    echo "Aborted. No new VM was created."
    exit 0
  fi
fi

# --- Choose VM name ---
default_vm_name="gcns-vm"
read -p "Enter a name for your new VM [${default_vm_name}]: " vm_name < /dev/tty
vm_name=${vm_name:-$default_vm_name}

# --- Choose region and zone ---
regions=("us-west1" "us-central1" "us-east1")
region=${regions[$RANDOM % ${#regions[@]}]}
zone=$(gcloud compute zones list --filter="region:($region)" --format="value(name)" | shuf -n 1)

echo
echo "Selected region: $region"
echo "Selected zone: $zone"
echo
echo "The following configuration will be used:"
echo "  VM name: $vm_name"
echo "  Region:  $region"
echo "  Zone:    $zone"
echo
read -p "Continue and create the VM? (Y/n): " proceed < /dev/tty
proceed=$(echo "$proceed" | tr '[:upper:]' '[:lower:]')
if [[ "$proceed" == "n" || "$proceed" == "no" ]]; then
  echo "Cancelled. No VM created."
  exit 0
fi

# --- Create the VM ---
echo
echo "🚀 Creating VM '${vm_name}' in zone '${zone}'..."
if ! gcloud compute instances create "$vm_name" \
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
  --no-enable-display-device; then
    echo
    echo "❌ VM creation failed. Please check your Google Cloud quotas or permissions."
    exit 1
fi

# --- Done ---
echo
echo "🎉 VM '${vm_name}' was created successfully in zone '${zone}'."
echo
echo "You can view and manage it in the Google Cloud Console:"
echo "  Menu > Compute Engine > VM instances"
echo

 
