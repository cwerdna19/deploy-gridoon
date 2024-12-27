#!/bin/bash

git -C ~/Gridoon pull
docker compose up -d --no-deps --build nodejs
docker volume rm gridoon-website_gridoon_data gridoon-website_nginx_secrets
docker image rm gridoon-website-nodejs jonasal/nginx-certbot
docker compose -f ~/Gridoon/docker-compose.yml -p gridoon-website up -d