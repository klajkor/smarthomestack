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

echo "CREATE 2 year retention policy"
echo "--------------"
docker exec -it influxdb influx -username ${INFLUXDB_ADMIN_USER} -password "${INFLUXDB_ADMIN_PASSWORD}"  -execute "USE sensors
CREATE RETENTION POLICY TwoYearHistorical ON sensors DURATION 104w REPLICATION 1"

echo "SHOW Retention Policy"
echo "-----------"
docker exec -it influxdb influx -username ${INFLUXDB_ADMIN_USER} -password "${INFLUXDB_ADMIN_PASSWORD}"  -execute "USE sensors
SHOW RETENTION POLICIES"
