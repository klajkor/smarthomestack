#!/bin/bash
#
# Initial config of Influxdb
#

STACKDIR=${HOME}/smarthomestack

cd ${STACKDIR}

set -o allexport
source influxdb.env
set +o allexport

influxdb_image=`grep "image: influxdb" docker-compose.yml | awk -F":" '{print $2":"$3}'`

docker run --rm -p 8086:8086 ${influxdb_image} influxd config > ${STACKDIR}/influxdb/influxdb.conf

sed -i 's/^\(  auth-enabled\s*=\s*\).*$/\1true/' ${STACKDIR}/influxdb/influxdb.conf

docker run --rm -e INFLUXDB_ADMIN_USER=${INFLUXDB_ADMIN_USER} -e INFLUXDB_ADMIN_PASSWORD=${INFLUXDB_ADMIN_PASSWORD} -v ${STACKDIR}/influxdb/db:/var/lib/influxdb ${influxdb_image} /init-influxdb.sh

docker-compose -f docker-compose.yml up -d influxdb

docker exec -it influxdb influx -execute "CREATE USER ${INFLUXDB_ADMIN_USER} WITH PASSWORD '${INFLUXDB_ADMIN_PASSWORD}' WITH ALL PRIVILEGES"

docker exec -it influxdb influx  -username ${INFLUXDB_ADMIN_USER} -password "${INFLUXDB_ADMIN_PASSWORD}" -execute 'CREATE DATABASE sensors'

docker exec -it influxdb influx -username ${INFLUXDB_ADMIN_USER} -password "${INFLUXDB_ADMIN_PASSWORD}"  -execute "USE sensors  
CREATE USER ${INFLUXDB_TELEGRAF_USER} WITH PASSWORD '${INFLUXDB_TELEGRAF_PASSWORD}'"

docker exec -it influxdb influx -username ${INFLUXDB_ADMIN_USER} -password "${INFLUXDB_ADMIN_PASSWORD}"  -execute "USE sensors  
GRANT ALL on sensors TO telegraf"

curl -G http://localhost:8086/query  --data-urlencode "u=${INFLUXDB_ADMIN_USER}" --data-urlencode "p=${INFLUXDB_ADMIN_PASSWORD}" --data-urlencode "q=SHOW DATABASES"

docker-compose -f docker-compose.yml down
