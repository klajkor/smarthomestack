#!/bin/bash
#
# Initial config of Zigbee2MQTT
#

if [ ! -e .env ]
then
    echo "<!> Please create proper .env file! Exiting."
    exit 1
fi

if [ ! -e zigbee_dongle.env ]
then
    echo "<!> Please create proper zigbee_dongle.env file! Exiting."
    exit 1
fi

if [ ! -e mqtt.env ]
then
    echo "<!> Please create proper mqtt.env file! Exiting."
    exit 2
fi

set -o allexport
source .env
source mqtt.env
source zigbee_dongle.env
set +o allexport

cd ${STACKDIR}

zigbee2mqtt_image=`grep "image: zigbee2mqtt" docker-compose.yml | awk -F":" '{print $2":"$3}'`

echo "Docker compose down"
${COMPOSECOMMAND} -f docker-compose.yml down

CONFIGFILE="${STACKDIR}/zigbee2mqtt/data/configuration.yaml"

echo "Creating real Zigbee2MQTT config file: ${CONFIGFILE}"
echo -e '
homeassistant: false
permit_join: true
mqtt:
  base_topic: zigbee2mqtt
  server: tcp://mosquitto:1883
  user: '${MQTT_USER}'
  password: '${MQTT_PASSWORD}'
serial:
  port: /dev/ttyACM0
advanced:
  homeassistant_legacy_entity_attributes: false
  legacy_api: false
  legacy_availability_payload: false
  network_key: GENERATE
device_options:
  legacy: false
frontend: true

' > ${CONFIGFILE}
echo "Setting file permissions of ${CONFIGFILE}"
sudo chown -R ${USER}:docker ${CONFIGFILE}

echo "Compose down"
${COMPOSECOMMAND} -f docker-compose.yml down