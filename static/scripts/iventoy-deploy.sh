#!/bin/bash
#
# Script name: iventoy-deploy.sh
# Author: King Tam
# Website: https://kingtam.eu.org
# Date: January 27, 2025
# Purpose: Automatic creation of iPXE service on Linux.
#

# Variables
URL="https://github.com/ventoy/PXE/releases/download/v1.0.20/iventoy-1.0.20-linux-free.tar.gz"
DEST_DIR="/opt/iventoy"
SERVICE_FILE="/etc/systemd/system/iventoy.service"
SCRIPT_NAME=$(basename "$0")

# Download iVentoy
wget $URL -O /tmp/iventoy.tar.gz

# Extract the package
tar -xvzf /tmp/iventoy.tar.gz -C /opt

# Rename Directory
mv /opt/iventoy-1.0.20 /opt/iventoy

# Remove the downloaded archive
rm /tmp/iventoy.tar.gz

# Create systemd service file
cat << EOF > $SERVICE_FILE
[Unit]
Description=iVentoy iPXE Server
Requires=network-online.target
After=network-online.target
Wants=network-online.target

[Service]
Type=forking
User=root
Group=root
WorkingDirectory=$DEST_DIR
ExecStart=$DEST_DIR/iventoy.sh -R start
ExecStop=$DEST_DIR/iventoy.sh stop

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to recognize the new service
systemctl daemon-reload

# Enable the service to start on boot
systemctl enable iventoy

# Start the service
systemctl start iventoy

# Remove the script itself
rm -- "$0"
