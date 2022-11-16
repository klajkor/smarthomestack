#!/bin/bash
#
# Build the entire stack from scratch
#

echo "=> Build the entire stack from scratch"

bash "./01_create_local_env_file.sh"

if [ ! -e .env ]
then
  cp .env-example .env
fi 
echo "=> Please check the basic environment paramters in .env file"
cat .env
read -p "=> Press any key to load .env file ti vi editor"
vi .env
if [ ! -e mqtt.env ]
then
  cp mqtt.env-example mqtt.env
fi
echo "=> Now please adjust the passwords to your needs in mqtt.env file"
cat mqtt.env
read -p "=> Press any key to load mqtt.env file ti vi editor"
vi mqtt.env

if [ ! -e influxdb.env ]
then
  cp influxdb.env-example influxdb.env
fi
echo "=> Now please adjust the passwords to your needs in influxdb.env file"
cat influxdb.env
read -p "=> Press any key to load influxdb.env file ti vi editor"
vi influxdb.env

if [ ! -e zigbee_dongle.env ]
then
  cp zigbee_dongle.env-example zigbee_dongle.env
fi
echo "=> Now please adjust the serial ID to your needs in zigbee_dongle.env file"
cat zigbee_dongle.env
read -p "=> Press any key to load zigbee_dongle.env file ti vi editor"
vi zigbee_dongle.env

BUILD_SCRIPTS="10_folder_setup.sh 11_config_skeletons.sh 19_docker_compose_init.sh 20_mosquitto_config.sh 21_influxdb_config.sh 22_telegraf_config.sh 23_zigbee2mqtt_config.sh"
for SCRIPT in $BUILD_SCRIPTS
do
  echo "=> Starting ${SCRIPT} script:"
  bash "./${SCRIPT}"
  read -p "=> ${SCRIPT} finished, press any key"
done

echo " "
echo "=> Build script finished"