#!/bin/bash
#
# Initial config of Docker Compose
#

STACKDIR=${HOME}/smarthomestack

cd ${STACKDIR}
#if [ ! -e pgsql.env ]
#then
#    cp pgsql.env-example pgsql.env
#    echo "Don't forget to update pgsql.env file!"
#fi

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

COMPOSEFILE=${STACKDIR}/docker-compose.yml
echo "docker clean-up"
docker system prune -f;docker image prune -f;docker volume prune -f

echo "Validating: ${COMPOSEFILE}"
docker-compose -f ${COMPOSEFILE} config
read -p "=> Validating finished, press any key"

echo "Initiate downloading of docker images from Docker Hub"
docker-compose -f ${COMPOSEFILE} pull

echo "First docker-compose run, errors messages expected due to lack of proper config files"
docker-compose -f ${COMPOSEFILE} up -d

echo "Stopping all containers"
docker-compose -f ${COMPOSEFILE} down

echo "Docker clean-up again"
docker system prune -f;docker image prune -f;docker volume prune -f
