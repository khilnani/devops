#!/bin/sh -x

# Import the public repository GPG keys
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# Register the Microsoft Ubuntu repository
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft.list

# Update apt-get
apt-get update

# Install PowerShell
apt-get install -y powershell

echo "# Start PowerShell: powershell"
