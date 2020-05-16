#!/bin/bash
#
# Initial config of Telegraf
#

cd ~/smarthomestack

if [ ! -e influxdb.env ]
then
    echo "Please create proper influxdb.env file!"
    exit 1
fi

if [ ! -e mqtt.env ]
then
    echo "Please create proper mqtt.env file!"
    exit 2
fi

set -o allexport
source mqtt.env
source influxdb.env
set +o allexport

docker-compose -f docker-compose.yml down

docker run --rm telegraf telegraf config > ~/smarthomestack/telegraf/telegraf.conf

mv  ~/smarthomestack/telegraf/telegraf.conf  ~/smarthomestack/telegraf/telegraf.conf-original

echo -e '
##
## Telegraf config for smarthomestack 
##
[global_tags]
#
[agent]
  interval = "10s"
  round_interval = true
  metric_batch_size = 1000
  metric_buffer_limit = 10000
  collection_jitter = "0s"
  flush_interval = "10s"
  flush_jitter = "0s"
  precision = ""
  hostname = ""
  omit_hostname = false


[[outputs.influxdb]]
  urls = ["http://influxdb:8086"]
  database = "sensors"
  skip_database_creation = true
  retention_policy = ""
  write_consistency = "any"
  username = "'${INFLUXDB_TELEGRAF_USER}'"
  password = "'${INFLUXDB_TELEGRAF_PASSWORD}'"
  user_agent = "telegraf"


[[inputs.mqtt_consumer]]
  servers = ["tcp://mosquitto:1883"]
  qos = 0
  persistent_session = false
  connection_timeout = "30s"
  topics = [ "tele/+/SENSOR" ]
  client_id = "telegraf0"
  data_format = "json"
  json_time_key = "Time"
  json_time_format ="2006-01-02T15:04:05"
  username = "'${MQTT_USER}'"
  password = "'${MQTT_PASSWORD}'"


[[inputs.mqtt_consumer]]
  servers = ["tcp://mosquitto:1883"]
  qos = 0
  persistent_session = false
  connection_timeout = "30s"
  topics = [ "stat/+/POWER1" ]
  client_id = "telegraf1"
  data_format = "value"
  data_type = "string"
  username = "'${MQTT_USER}'"
  password = "'${MQTT_PASSWORD}'"


[[inputs.mqtt_consumer]]
  servers = ["tcp://mosquitto:1883"]
  persistent_session = false
  qos = 0
  connection_timeout = "30s"
  topics = [ "stat/+/POWER2" ]
  client_id = "telegraf2"
  data_format = "value"
  data_type = "string"
  username = "'${MQTT_USER}'"
  password = "'${MQTT_PASSWORD}'"

' > ~/smarthomestack/telegraf/telegraf.conf

docker-compose -f docker-compose.yml down