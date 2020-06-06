#!/bin/bash
#
# Config skeletons
#
USER=`id -un`
USERID=`id -u`
#Docker group ID
GROUPID=`getent group docker | cut -d: -f3`
SUBDIR="smarthomestack"

cd ~/${SUBDIR}
echo "PUID=${USERID}
PGID=${GROUPID}
TZ=Europe/Budapest
USERDIR=/home/${USER}
STACKDIR=/home/${USER}/${SUBDIR}
" > .env

echo "MYSQL_ROOT_PASSWORD=super_password
" > mysql.env-example

echo "INFLUXDB_ADMIN_USER=admin
INFLUXDB_ADMIN_PASSWORD=super_password
INFLUXDB_TELEGRAF_USER=telegraf
INFLUXDB_TELEGRAF_PASSWORD=super_telegraf_password
" > influxdb.env-example

echo "MQTT_USER=MQTT_user
MQTT_PASSWORD=super_password
" > mqtt.env-example

echo "PG_USER=pguser
PG_PWD=super_password
PG_DB=pgdatabase
" > pgsql.env-example

echo 'env $(cat /home/'${USER}'/'${SUBDIR}'/.env) /usr/local/bin/docker-compose -f /home/'${USER}'/'${SUBDIR}'/docker-compose.yml up -d' > stack_up.sh
chmod 755 stack_up.sh

echo 'env $(cat /home/'${USER}'/'${SUBDIR}'/.env) /usr/local/bin/docker-compose -f /home/'${USER}'/'${SUBDIR}'/docker-compose.yml down' > stack_down.sh
chmod 755 stack_down.sh

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
mqtt: !include mqtt_config.yaml
sensor: !include sensor_config.yaml
switch: !include switch_config.yaml
' > ~/${SUBDIR}/homeassistant/configuration.yaml


