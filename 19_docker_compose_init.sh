#!/bin/bash
#
# Initial config of Docker Compose
#

#clean-up
docker system prune -f;docker image prune -f;docker volume prune -f

#Initiate downloading of docker images from Docker Hub
docker-compose -f ~/smarthomestack/docker-compose.yml up -d

#Stopping all containers
docker-compose -f ~/smarthomestack/docker-compose.yml down -d

#clean-up
docker system prune -f;docker image prune -f;docker volume prune -f