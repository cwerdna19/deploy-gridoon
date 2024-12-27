#!/bin/bash

git -C ~/Gridoon pull
docker compose up -d --no-deps --build nodejs
docker compose -f ~/Gridoon/docker-compose.yml -p gridoon-website up -d