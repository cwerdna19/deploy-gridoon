#!/bin/bash

# Exit on any error
set -e

# Update and upgrade the system
apt-get update && apt-get upgrade -y

# Install Docker and Git
curl -fsSL https://get.docker.com -o get-docker.sh
chmod +x get-docker.sh
sh get-docker.sh
apt-get install -y docker-compose-plugin git ufw

# Configure Git to store credentials indefinitely
git config --global credential.helper store

# Temporarily set Git credentials
GIT_USERNAME="your_username"
GIT_PASSWORD="your_password"

# Store the credentials using the git credential helper
echo "protocol=https
host=github.com
username=$GIT_USERNAME
password=$GIT_PASSWORD" | git credential approve

# Clone the repository
git clone https://github.com/hashtagbowl/Gridoon ~/Gridoon

# Make scripts executable
chmod +x ~/deploy-gridoon/update-gridoon.sh

# Set alias for update-gridoon so it can be easily ran
alias update-gridoon='sh ~/deploy-gridoon/update-gridoon.sh'

# Make .env
cp ~/Gridoon/nginx-certbot.example.env ~/Gridoon/nginx-certbot.env

# Enable UFW and open port 443
ufw allow 80
ufw allow 443
ufw allow 22
echo "y" | ufw enable

# Build and run Docker image
docker compose -f ~/Gridoon/docker-compose.yml -p gridoon-website up -d
