#!/bin/bash

# Exit on any error
set -e

# Update and upgrade the system
echo "Updating packages"
apt-get update && apt-get upgrade -y

# Install Docker, Git and UFW
echo "Installing Docker, Git and UFW"
curl -fsSL https://get.docker.com -o get-docker.sh
chmod +x get-docker.sh
sh get-docker.sh
apt-get install -y docker-compose-plugin git ufw

# Configure Git to store credentials indefinitely
git config --global credential.helper store

# Temporarily set Git credentials
read -p "Enter your Github username: " GIT_USERNAME
echo
read -s -p "Enter your Github Personal Access Token: " GIT_PASSWORD
echo
read -p "Enter your email address: " EMAIL
echo
read -p "What is the domain name you'll be using?: " DOMAIN_NAME
echo

# Store the credentials using the git credential helper
echo "Setting git credentials"
echo "protocol=https
host=github.com
username=$GIT_USERNAME
password=$GIT_PASSWORD" | git credential approve

# Clone the repository
echo "Cloning the app repo"
git clone https://github.com/hashtagbowl/Gridoon ~/Gridoon

# Make scripts executable
echo "Making scripts executable"
chmod +x ~/deploy-gridoon/update-gridoon.sh

# Set alias for update-gridoon so it can be easily ran
alias update-gridoon='sh ~/deploy-gridoon/update-gridoon.sh'

# Make .env
echo "Setting config variables"
cp ~/Gridoon/nginx-certbot.example.env ~/Gridoon/nginx-certbot.env
sed -i 's/your@email.org/${EMAIL}/g' ~/Gridoon/nginx-certbot.env
sed -i 's/gridoon.com/${DOMAIN_NAME}/g' ~/Gridoon/user_conf.d/nginx.conf
sed -i 's/www.gridoon.com/www.${DOMAIN_NAME}/g' ~/Gridoon/user_conf.d/nginx.conf


# Enable UFW and open port 443
echo "Opening ports 80, 443, and 22"
ufw allow 80
ufw allow 443
ufw allow 22
echo "y" | ufw enable
ufw reload

# Build and run Docker image
echo "Making and running docker containers"
docker compose -f ~/Gridoon/docker-compose.yml -p gridoon-website up -d

echo "You're good to go! You can reach your website at ${DOMAIN_NAME}\nUpdate the app with by entering 'sudo update-gridoon'\nAdd books by entering ' sudo get-books"