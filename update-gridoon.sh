#!/bin/bash

git -C ~/Gridoon pull
docker compose -f ~/Gridoon/docker-compose-init-certs.yml -p gridoon-website up -d