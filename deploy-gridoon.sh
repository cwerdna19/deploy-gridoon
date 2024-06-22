#!/bin/bash

# Exit on any error
set -e

# Temporarily set Git credentials
GIT_USERNAME="your_username"
GIT_PASSWORD="your_password"
GIT_CREDENTIALS_PATH=$(git config --global credential.helper | awk '{print $2}')

# Update and upgrade the system
apt-get update
apt-get upgrade -y

# Install Docker and Git
curl -fsSL https://get.docker.com -o get-docker.sh
chmod +x get-docker.sh
sh get-docker.sh
apt-get install -y docker-compose-plugin git ufw

# Configure Git to store credentials indefinitely
git config --global credential.helper store

# Create a credentials file with the credentials
echo "https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com" > ~/.git-credentials

# Clone the repository
git clone https://github.com/hashtagbowl/Gridoon

# Clean up the temporary credentials
rm ~/.git-credentials

# Ensure credentials are stored in the global configuration
git config --global credential.helper store

# Make update script executable
chmod +x update-gridoon.sh
alias update-gridoon='sh update-gridoon.sh'

# Enable UFW and open port 443
ufw enable
ufw allow 443

# Build and run Docker image
docker compose -f ~/Gridoon/docker-compose.yml -p gridoon-website up -d
