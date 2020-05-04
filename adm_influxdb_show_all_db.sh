#!/bin/bash
#
# Testing Influxdb - container must be in running state
#

cd ~/smarthomestack

set -o allexport
source influxdb.env
set +o allexport

curl -G http://localhost:8086/query  --data-urlencode "u=${INFLUXDB_ADMIN_USER}" --data-urlencode "p=${INFLUXDB_ADMIN_PASSWORD}" --data-urlencode "q=SHOW DATABASES"

docker exec -it influxdb influx -username ${INFLUXDB_ADMIN_USER} -password "${INFLUXDB_ADMIN_PASSWORD}"  -execute "USE sensors
SHOW DATABASES"

