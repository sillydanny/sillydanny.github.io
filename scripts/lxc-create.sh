#!/bin/bash
#
# Script name: lxc-create.sh
# Author: King Tam
# Website: https://kingtam.eu.org
# Date: February 12, 2025
# Purpose: Automatic creation of LXC on Proxmox VE.
#

#!/bin/bash

# Function to display error messages and exit
error_exit() {
    echo "$1" >&2
    exit 1
}

# Prompt for LXC ID and password
read -p "Enter LXCID: " LXCID
read -sp "Enter PASSWD: " PASSWD
echo

# Validate LXCID (must be a number)
if ! [[ "$LXCID" =~ ^[0-9]+$ ]]; then
    error_exit "Invalid LXCID. Please enter a numeric value."
fi

# Template file and URL
TEMPLATE_FILE="/var/lib/vz/template/cache/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
TEMPLATE_URL="http://download.proxmox.com/images/system/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"

# Check if LXCID already exists
if pct list | grep -q "^$LXCID\s"; then
    read -p "LXCID $LXCID already exists. Do you want to remove the existing container (y/n)? " REMOVE_CONTAINER
    if [[ "$REMOVE_CONTAINER" =~ ^[Yy]$ ]]; then
        echo "Stopping and destroying container $LXCID..."
        pct stop "$LXCID" || error_exit "Failed to stop container $LXCID."
        pct destroy "$LXCID" --force || error_exit "Failed to destroy container $LXCID."
    else
        echo "Exiting."
        exit 0
    fi
fi

# Download template if it doesn't exist
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo "Downloading CT template..."
    if ! wget -q "$TEMPLATE_URL" -P /var/lib/vz/template/cache/; then
        error_exit "Failed to download CT template. Exiting."
    fi
fi

# Create the LXC container
echo "Creating container $LXCID..."
pct create "$LXCID" local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst \
  --storage local-lvm --rootfs volume=local-lvm:12 \
  --ostype ubuntu --arch amd64 --password "$PASSWD" --unprivileged 0 \
  --cores 2 --memory 1024 --swap 0 \
  --hostname "lxc-$LXCID" \
  --net0 name=eth0,bridge=vmbr0,ip=dhcp,firewall=1,type=veth \
  || error_exit "Failed to create container $LXCID."

# Append additional configuration
echo "Configuring container $LXCID..."
cat << EOF | tee -a "/etc/pve/lxc/$LXCID.conf" > /dev/null
lxc.cgroup2.devices.allow: c 226:0 rwm
lxc.cgroup2.devices.allow: c 226:128 rwm
lxc.cgroup2.devices.allow: c 29:0 rwm
lxc.mount.entry: /dev/dri dev/dri none bind,optional,create=dir
lxc.mount.entry: /dev/fb0 dev/fb0 none bind,optional,create=file
lxc.apparmor.profile: unconfined
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net dev/net none bind,create=dir
EOF

# Start the container
read -p "Do you want to start the container now (y/n)? " START_CONTAINER
if [[ "$START_CONTAINER" =~ ^[Yy]$ ]]; then
    echo "Starting container $LXCID..."
    pct start "$LXCID" || error_exit "Failed to start container $LXCID."
else
    echo "Container $LXCID created successfully. Start it manually with: pct start $LXCID"
fi

echo "Script completed successfully."