#!/bin/bash
#
# Config skeletons
#

echo "=> Creating config skeletons started"

USER=`id -un`
USERID=`id -u`
#Docker group ID
GROUPID=`getent group docker | cut -d: -f3`

if [ ! -e .env ]
then
    echo "<!> Please create proper .env file! Exiting."
    exit 1
fi

set -o allexport
source .env
source mqtt.env
set +o allexport

# ${STACKDIR} is from .env
cd ${STACKDIR}

echo 'env $(cat '${STACKDIR}'/.env) '${COMPOSECOMMAND}' -f '${STACKDIR}'/docker-compose.yml up -d' > stack_up.sh
chmod 755 stack_up.sh

echo 'env $(cat '${STACKDIR}'/.env) '${COMPOSECOMMAND}' -f '${STACKDIR}'/docker-compose.yml down' > stack_down.sh
chmod 755 stack_down.sh

echo -e '
  broker: mosquitto
  username: '${MQTT_USER}'
  password: '${MQTT_PASSWORD}'
  discovery: true
  discovery_prefix: homeassistant
' > ${STACKDIR}/homeassistant/mqtt_config.yaml-example
echo "Please don't forget to create a valid ./homeassistant/mqtt_config.yaml with proper credentials"
echo "Go to subdirectory: cd ./homeassistant"
echo "Copy the example file: cp mqtt_config.yaml-example mqtt_config.yaml"
echo "Then edit it: vi mqtt_config.yaml OR nano mqtt_config.yaml"
echo " "

TS=$(date +"%Y%m%d%H%M%S")

if [ -e ${STACKDIR}/homeassistant/configuration.yaml ]
then
    cp ${STACKDIR}/homeassistant/configuration.yaml ${STACKDIR}/homeassistant/configuration.yaml_${TS}
fi

echo -e '
# Configure a default setup of Home Assistant (frontend, api, etc)
default_config:

# Text to speech
tts:
  - platform: google_translate

group: !include groups.yaml
automation: !include automations.yaml
script: !include scripts.yaml
scene: !include scenes.yaml

mqtt: !include mqtt_config.yaml
sensor: !include sensor_config.yaml
switch: !include switch_config.yaml

' > ${STACKDIR}/homeassistant/configuration.yaml

echo "=> Creating config skeletons completed"
