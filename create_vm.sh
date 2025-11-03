#!/bin/bash
# Create a Nightscout VM with a random free-tier region
# curl https://raw.githubusercontent.com/Navid200/cgm-remote-monitor/VmInstallCloudShell_Test/create_vm.sh | bash
# Checks if an instance already exists before proceeding

if [[ "$CLOUD_SHELL" != true ]]; then
  echo "You can only run this script in Cloud Shell."
  echo "Terminating"
  exit 0
fi

existing_vms=$(gcloud compute instances list --format="value(name)")

if [[ -n "$existing_vms" ]]; then
  echo "⚠️  Existing virtual machines found:"
  echo "$existing_vms"
  echo
  read -p "Do you still want to create a new VM? (y/N): " confirm
  confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')
  if [[ "$confirm" != "y" && "$confirm" != "yes" ]]; then
    echo "Aborted. No new VM was created."
    exit 0
  fi
fi

regions=("us-west1" "us-central1" "us-east1")
region=${regions[$RANDOM % ${#regions[@]}]}
zone=$(gcloud compute zones list --filter="region:($region)" --format="value(name)" | shuf -n 1)

echo "Selected region: $region"
echo "Selected zone:   $zone"
echo

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
  
  
