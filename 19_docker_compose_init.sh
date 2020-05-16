#!/bin/bash
#
# Initial config of Docker Compose
#

STACKDIR=${HOME}/smarthomestack

cd ${STACKDIR}
if [ ! -e pgsql.env ]
then
    cp pgsql.env-example pgsql.env
    echo "Don't forget to update pgsql.env file!"
fi

if [ ! -e influxdb.env ]
then
    cp influxdb.env-example influxdb.env
    echo "Don't forget to update influxdb.env file!"
fi

if [ ! -e mqtt.env ]
then
    cp mqtt.env-example mqtt.env
    echo "Don't forget to update mqtt.env file!"
fi

#clean-up
docker system prune -f;docker image prune -f;docker volume prune -f

#Initiate downloading of docker images from Docker Hub
docker-compose -f ${STACKDIR}/docker-compose.yml pull

#First run, errors messages expected due to lack of propoer config files
docker-compose -f ${STACKDIR}/docker-compose.yml up -d

#Stopping all containers
docker-compose -f ${STACKDIR}/docker-compose.yml down

#clean-up
docker system prune -f;docker image prune -f;docker volume prune -f
