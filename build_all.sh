#!/bin/bash
#
# Build the entire stack from scratch
#
cp .env-example .env
echo "Please check the basic environment paramters in .env file"
cat .env
read -p "=> Press any key"
vi .env
cp mqtt.env-example mqtt.env
echo "Now please adjust the dummy passwords to your needs in mqtt.env file"
cat mqtt.env
read -p "=> Press any key"
vi mqtt.env
cp influxdb.env-example influxdb.env
echo "Now please adjust the dummy passwords to your needs in influxdb.env file"
cat influxdb.env
read -p "=> Press any key"
vi influxdb.env
BUILD_SCRIPTS="10_folder_setup.sh 11_config_skeletons.sh 19_docker_compose_init.sh 20_mosquitto_config.sh 21_influxdb_config.sh 22_telegraf_config.sh"
for SCRIPT in $BUILD_SCRIPTS
do
  OUTPUT=`"$SCRIPT"`
  echo "$SCRIPT output:"
  echo $OUTPUT
  read -p "=> Press any key"
done