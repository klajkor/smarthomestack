#!/bin/bash
#
# Initial config of Mosquitto
#

STACKDIR=${HOME}/smarthomestack

cd ${STACKDIR}

if [ ! -e mqtt.env ]
then
    echo "Please create proper mqtt.env file!"
    exit 1
fi

set -o allexport
source mqtt.env
set +o allexport

docker-compose -f docker-compose.yml down

docker-compose -f docker-compose.yml up -d influxdb

docker run --rm eclipse-mosquitto sh -c "mosquitto_passwd -b /mosquitto/config/passwd ${MQTT_USER} ${MQTT_PASSWORD}"
docker run --rm eclipse-mosquitto sh -c "cat /mosquitto/config/passwd"

#docker-compose exec mosquitto sh -c "mosquitto_passwd -b /mosquitto/config/passwd ${MQTT_USER} ${MQTT_PASSWORD}"
#docker-compose exec mosquitto sh -c "cat /mosquitto/config/passwd"

docker-compose -f docker-compose.yml down

echo 'mqtt: !include mqtt_config.yaml' >> ${STACKDIR}/homeassistant/configuration.yaml
echo 'sensor: !include sensor_config.yaml' >> ${STACKDIR}/homeassistant/configuration.yaml

