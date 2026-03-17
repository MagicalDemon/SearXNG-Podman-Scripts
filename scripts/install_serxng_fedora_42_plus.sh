#!/bin/bash
# Filename: install_serxng_fedora_42_plus.sh
# Created: 21th June, 2024
# Updated: 15th March, 2026
# Description: This script automates the installation and setup of SearXNG using Podman on Fedora 42 or greater versions.
# It includes steps to update the system, install Podman, pull the SearXNG Docker image, create necessary
# configuration files, run the SearXNG container with the correct port mapping, and set up a systemd service
# to ensure the container starts automatically on system boot.

# Update system
sudo dnf update -y

# Install Podman
sudo dnf install -y podman

# Verify Podman installation
podman --version

# Pull the SearXNG Docker image
podman pull docker.io/searxng/searxng:latest

# Create a directory for SearXNG configuration in your home directory
mkdir -p ~/searxng/settings

# Create a configuration file with default settings
curl -o ~/searxng/settings/settings.yml https://raw.githubusercontent.com/searxng/searxng/refs/heads/master/searx/settings.yml

# Comment the secret_key line in the settings.yml file
sed -i 's/secret_key: "ultrasecretkey"  # Is overwritten by ${SEARXNG_SECRET}/# &/' ~/searxng/settings/settings.yml

# Run the SearXNG container with correct port mapping
podman run -d --name searxng -p 8888:8080 -v ~/Documents/searxng/settings/settings.yml:/etc/searxng/settings.yml:Z docker.io/searxng/searxng:latest

# Verify the container is running
podman ps

# Create a systemd service file for the SearXNG container
sudo tee /etc/systemd/system/searxng.service > /dev/null <<EOF
[Unit]
Description=SearXNG container
After=network.target

[Service]
ExecStartPre=/bin/sleep 30
Restart=always
ExecStart=/usr/bin/podman start -a searxng
ExecStop=/usr/bin/podman stop -t 2 searxng

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable the SearXNG service to start on boot
sudo systemctl enable searxng

# Start the SearXNG service
sudo systemctl start searxng

# Fetch the server's hostname
hostname=$(hostname)

# Output the URL to access SearXNG
echo "SearXNG is running. Access it at http://$hostname:8888/"

# Credit to the original file owner https://gist.github.com/ParkWardRR/602e01042aceedc882972bb3ec5c1e4f