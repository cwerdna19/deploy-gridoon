#!/bin/bash

git -C ~/Gridoon pull
docker compose -f ~/Gridoon/docker-compose.yml -p gridoon-website up -d