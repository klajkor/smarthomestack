#!/bin/bash
#
# Config skeletons
#
USER=`id -un`
USERID=`id -u`
#Docker group ID
GROUPID=`getent group docker | cut -d: -f3`
SUBDIR="smarthomestack"
STACKDIR=/home/${USER}/${SUBDIR}

cd ~/${SUBDIR}
echo "PUID=${USERID}
PGID=${GROUPID}
TZ=Europe/Budapest
USERDIR=/home/${USER}
STACKDIR=/home/${USER}/${SUBDIR}
" > .env

echo 'env $(cat /home/'${USER}'/'${SUBDIR}'/.env) /usr/local/bin/docker-compose -f /home/'${USER}'/'${SUBDIR}'/docker-compose.yml up -d' > stack_up.sh
chmod 755 stack_up.sh

echo 'env $(cat /home/'${USER}'/'${SUBDIR}'/.env) /usr/local/bin/docker-compose -f /home/'${USER}'/'${SUBDIR}'/docker-compose.yml down' > stack_down.sh
chmod 755 stack_down.sh

echo -e "listener 1883
log_dest file /mosquitto/log/mosquitto.log
log_timestamp_format %Y-%m-%d %H:%M:%S
allow_anonymous false
password_file /mosquitto/config/passwd
persistence_location /mosquitto/data/
persistence_file mosquitto.db
persistence true \n" > ~/${SUBDIR}/mosquitto/config/mosquitto.conf

echo -e "
  broker: mosquitto
  username: YOUR_MQTT_USER
  password: YOUR_MQTT_PASSWD
  discovery: true
  discovery_prefix: homeassistant
" > ~/${SUBDIR}/homeassistant/mqtt_config.yaml-example
echo "Please don't forget to create a valid ./homeassistant/mqtt_config.yaml with proper credentials"
echo "Go to subdirectory: cd ./homeassistant"
echo "Copy the example file: cp mqtt_config.yaml-example mqtt_config.yaml"
echo "Then edit it: vi mqtt_config.yaml OR nano mqtt_config.yaml"
echo " "

TS=$(date +"%Y%m%d%H%M%S")

if [ -e ~/${SUBDIR}/homeassistant/configuration.yaml ]
then
    cp ~/${SUBDIR}/homeassistant/configuration.yaml ~/${SUBDIR}/homeassistant/configuration.yaml_${TS}
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

' > ~/${SUBDIR}/homeassistant/configuration.yaml


