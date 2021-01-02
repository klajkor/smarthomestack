#!/bin/bash
#
# Build the entire stack from scratch
#
if [ ! -e .env ]
then
  cp .env-example .env
fi 
echo "Please check the basic environment paramters in .env file"
cat .env
read -p "=> Press any key"
vi .env
if [ ! -e mqtt.env ]
then
  cp mqtt.env-example mqtt.env
fi
echo "Now please adjust the passwords to your needs in mqtt.env file"
cat mqtt.env
read -p "=> Press any key"
vi mqtt.env
if [ ! -e influxdb.env ]
then
  cp influxdb.env-example influxdb.env
fi
echo "Now please adjust the passwords to your needs in influxdb.env file"
cat influxdb.env
read -p "=> Press any key"
vi influxdb.env
BUILD_SCRIPTS="10_folder_setup.sh 11_config_skeletons.sh 19_docker_compose_init.sh 20_mosquitto_config.sh 21_influxdb_config.sh 22_telegraf_config.sh"
for SCRIPT in $BUILD_SCRIPTS
do
  OUTPUT=`"./${SCRIPT}"`
  echo "$SCRIPT output:"
  echo $OUTPUT
  read -p "=> Press any key"
done