#!/bin/bash
#
# Initial config of Docker Compose
#

echo "=> Docker Compose init started"

if [ ! -e .env ]
then
    echo "<!> Please create proper .env file! Exiting."
    exit 1
fi

set -o allexport
source .env
set +o allexport

# ${STACKDIR} is from .env
cd ${STACKDIR}

if [ ! -e influxdb.env ]
then
    cp influxdb.env-example influxdb.env
    echo "=> Don't forget to update influxdb.env file!"
fi

if [ ! -e mqtt.env ]
then
    cp mqtt.env-example mqtt.env
    echo "=> Don't forget to update mqtt.env file!"
fi

if [ ! -e zigbee_dongle.env ]
then
    cp zigbee_dongle.env-example zigbee_dongle.env
    echo "=> Don't forget to update zigbee_dongle.env file!"
fi

COMPOSEFILE=${STACKDIR}/docker-compose.yml
echo "docker clean-up"
docker system prune -f;docker image prune -f;docker volume prune -f

echo "Validating: ${COMPOSEFILE}"
${COMPOSECOMMAND} -f ${COMPOSEFILE} config
read -p "=> Validating finished, press any key"

echo "Initiate downloading of docker images from Docker Hub"
${COMPOSECOMMAND} -f ${COMPOSEFILE} pull

echo "First ${COMPOSECOMMAND} run, errors messages expected due to lack of proper config files"
${COMPOSECOMMAND} -f ${COMPOSEFILE} up -d

echo "Stopping all containers"
${COMPOSECOMMAND} -f ${COMPOSEFILE} down

echo "Docker clean-up again"
docker system prune -f;docker image prune -f;docker volume prune -f

echo "=> Docker Compose init completed"