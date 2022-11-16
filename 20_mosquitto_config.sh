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

echo "Creating base config file"

echo -e "listener 1883
log_dest file /mosquitto/log/mosquitto.log
log_timestamp_format %Y-%m-%d %H:%M:%S
allow_anonymous false
password_file /mosquitto/config/passwd
persistence_location /mosquitto/data/
persistence_file mosquitto.db
persistence true \n" > ${STACKDIR}/mosquitto/config/mosquitto.conf

echo "Making sure that there is a passwd and log file"
MOSQUITTO_PASSWD_FILE=${STACKDIR}/mosquitto/config/passwd
MOSQUITTO_LOG_FILE=${STACKDIR}/mosquitto/log/mosquitto.log
if [ ! -e ${MOSQUITTO_PASSWD_FILE} ]
then
    touch ${MOSQUITTO_PASSWD_FILE}
fi
if [ ! -e ${MOSQUITTO_LOG_FILE} ]
then
    touch ${MOSQUITTO_LOG_FILE}
fi
sudo chmod -R ug+rw ${STACKDIR}/mosquitto
sudo chmod -R o+r ${STACKDIR}/mosquitto
sudo chmod -R ugo-x ${STACKDIR}/mosquitto/log/mosquitto.log
#This chown needed exactly as it is below!
sudo chown -R 1883:1883 ${STACKDIR}/mosquitto


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