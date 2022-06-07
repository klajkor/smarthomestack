#!/bin/bash
#
# Initial config of Mosquitto
#

echo "=> Initial config of Mosquitto started"

if [ ! -e .env ]
then
    echo "<!> Please create proper .env file! Exiting."
    exit 1
fi

if [ ! -e mqtt.env ]
then
    echo "<!> Please create proper mqtt.env file! Exiting."
    exit 1
fi

set -o allexport
source .env
source mqtt.env
set +o allexport

# ${STACKDIR} is from .env
cd ${STACKDIR}

echo "Shutting down container(s)"
${COMPOSECOMMAND} -f docker-compose.yml down

mosquitto_image=`grep "image: eclipse-mosquitto" docker-compose.yml | awk -F":" '{print $2":"$3}'`

echo "Making sure that there is a passwd and log file"
touch ${STACKDIR}/mosquitto/config/passwd
touch ${STACKDIR}/mosquitto/log/mosquitto.log
sudo chown -R ${USER}:docker ${STACKDIR}/mosquitto
sudo setfacl -Rdm g:docker:rw ${STACKDIR}/mosquitto
sudo chmod -R ug+rw ${STACKDIR}/mosquitto
sudo chmod -R o+r ${STACKDIR}/mosquitto
sudo chown -R 1883:1883 ${STACKDIR}/mosquitto/log/mosquitto.log
sudo chmod -R ugo-x ${STACKDIR}/mosquitto/log/mosquitto.log

echo "Setting up password for image ${mosquitto_image}"
docker run --rm -v ${STACKDIR}/mosquitto/config:/mosquitto/config -v ${STACKDIR}/mosquitto/log:/mosquitto/log ${mosquitto_image} sh -c "mosquitto_passwd -b /mosquitto/config/passwd ${MQTT_USER} ${MQTT_PASSWORD}"

echo "/mosquitto/config/passwd:"
docker run --rm -v ${STACKDIR}/mosquitto/config:/mosquitto/config -v ${STACKDIR}/mosquitto/log:/mosquitto/log ${mosquitto_image} sh -c "cat /mosquitto/config/passwd"

echo "Starting up image ${mosquitto_image}"
${COMPOSECOMMAND} -f docker-compose.yml up -d mosquitto

echo "Show some logs, press Ctrl-C to quit from logs"
${COMPOSECOMMAND} -f docker-compose.yml logs --tail=50 -f

echo "Shutting down container(s)"
${COMPOSECOMMAND} -f docker-compose.yml down

echo 'mqtt: !include mqtt_config.yaml' >> ${STACKDIR}/homeassistant/configuration.yaml
echo 'sensor: !include sensor_config.yaml' >> ${STACKDIR}/homeassistant/configuration.yaml

echo "=> Initial config of Mosquitto completed"