#!/bin/bash
#
# Initial config of Docker Compose
#

cd ~/smarthomestack
if [ ! -e pgsql.env ]
then
    cp pgsql.env-example pgsql.env
fi

if [ ! -e influxdb.env ]
then
    cp influxdb.env-example influxdb.env
fi

#clean-up
docker system prune -f;docker image prune -f;docker volume prune -f

#Initiate downloading of docker images from Docker Hub
docker-compose -f ~/smarthomestack/docker-compose.yml pull

#First run, errors messages expected due to lack of propoer config files
docker-compose -f ~/smarthomestack/docker-compose.yml up -d

#Stopping all containers
docker-compose -f ~/smarthomestack/docker-compose.yml down

#clean-up
docker system prune -f;docker image prune -f;docker volume prune -f
