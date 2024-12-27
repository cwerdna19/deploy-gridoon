#!/bin/bash
cd /root/Gridoon
git -C ~/Gridoon pull
docker compose down --volumes --remove-orphans
docker image prune -f
docker image rm -f gridoon-website-nodejs jonasal/nginx-certbot
docker volume rm -f gridoon-website_gridoon_data gridoon-website_nginx_secrets
docker rm -f gridoon-nginx-certbot gridoon-nodejs
docker compose up -d --no-deps --build nodejs
docker compose -f ~/Gridoon/docker-compose.yml -p gridoon-website up -d