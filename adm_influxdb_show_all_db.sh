#!/bin/bash
#
# Testing Influxdb - container must be in running state
#

cd ~/smarthomestack

set -o allexport
source influxdb.env
set +o allexport
echo "Compose up influxdb"
docker-compose -f docker-compose.yml up -d influxdb

curl -G http://localhost:8086/query  --data-urlencode "u=${INFLUXDB_ADMIN_USER}" --data-urlencode "p=${INFLUXDB_ADMIN_PASSWORD}" --data-urlencode "q=SHOW DATABASES"

echo "SHOW DATABASES"
echo "--------------"
docker exec -it influxdb influx -username ${INFLUXDB_ADMIN_USER} -password "${INFLUXDB_ADMIN_PASSWORD}"  -execute "USE sensors
SHOW DATABASES"

echo "SHOW SERIES"
echo "-----------"
docker exec -it influxdb influx -username ${INFLUXDB_ADMIN_USER} -password "${INFLUXDB_ADMIN_PASSWORD}"  -execute "USE sensors
SHOW SERIES"

echo "Show last 10 values"
echo "-------------------"
docker exec -it influxdb influx -username ${INFLUXDB_ADMIN_USER} -password "${INFLUXDB_ADMIN_PASSWORD}"  -execute "USE sensors
precision rfc3339
SELECT * FROM mqtt_consumer ORDER BY time DESC LIMIT 10"

