#!/bin/bash
#
# Config skeletons
#
USER=`id -un`
USERID=`id -u`
GROUPID=`id -u`
SUBDIR="smarthomestack"

cd ~/${SUBDIR}
echo "PUID=${USERID}
PGID=${GROUPID}
TZ=Europe/Budapest
USERDIR=/home/${USER}
" > .env-example

echo "MYSQL_ROOT_PASSWORD=super_password
" > mysql.env-example

echo "PG_USER=pguser
PG_PWD=super_password
PG_DB=pgdatabase
" > pgsql.env-example

echo -e "port 1883
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

echo -e '
  - platform: mqtt
    name: "Test temperature"
    state_topic: "tele/test_sensor/SENSOR"
    unit_of_measurement: '°C'
    device_class: "temperature"
    value_template: "{{ value_json.SI7021.Temperature }}"
  - platform: mqtt
    name: "Test humidity"
    state_topic: "tele/test_sensor/SENSOR"
    unit_of_measurement: '%'
    device_class: "humidity"
    value_template: "{{ value_json.SI7021.Humidity }}"
' > ~/${SUBDIR}/homeassistant/sensor_config.yaml


