#!/bin/bash

docker pull docker.n8n.io/n8nio/n8n
docker image prune -f

# Navigate to the compose directory
cd /home/ec2-user/d-compose-n8n

# Restart N8N stack
docker compose up -d
