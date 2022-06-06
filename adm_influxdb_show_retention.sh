#!/bin/bash
#
# Show retention policies of Influxdb - container must be in running state
#

echo "=> Show retention policies of Influxdb - container must be in running state"

if [ ! -e .env ]
then
    echo "<!> Please create proper .env file! Exiting."
    exit 1
fi

if [ ! -e influxdb.env ]
then
    echo "<!> Please create proper influxdb.env file! Exiting."
    exit 1
fi

set -o allexport
source .env
source influxdb.env
set +o allexport

cd ${STACKDIR}

echo "Compose up influxdb"
${COMPOSECOMMAND} -f docker-compose.yml up -d influxdb

curl -G http://localhost:8086/query  --data-urlencode "u=${INFLUXDB_ADMIN_USER}" --data-urlencode "p=${INFLUXDB_ADMIN_PASSWORD}" --data-urlencode "q=SHOW DATABASES"

echo "SHOW DATABASES"
echo "--------------"
docker exec -it influxdb influx -username ${INFLUXDB_ADMIN_USER} -password "${INFLUXDB_ADMIN_PASSWORD}"  -execute "USE sensors
SHOW DATABASES"

echo "SHOW Retention Policy"
echo "-----------"
docker exec -it influxdb influx -username ${INFLUXDB_ADMIN_USER} -password "${INFLUXDB_ADMIN_PASSWORD}"  -execute "USE sensors
SHOW RETENTION POLICIES"
