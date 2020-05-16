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

docker-compose -f docker-compose.yml down

echo "Creating influxdb.conf for image ${influxdb_image}"
docker run --rm -p 8086:8086 ${influxdb_image} influxd config > ${STACKDIR}/influxdb/influxdb.conf

echo "Changing influxdb.conf file"
sed -i 's/^\(  auth-enabled\s*=\s*\).*$/\1true/' ${STACKDIR}/influxdb/influxdb.conf
sudo chown -R ${USER}:docker ${STACKDIR}/influxdb/influxdb.conf

echo "Init influxdb"
docker run --rm -e INFLUXDB_ADMIN_USER=${INFLUXDB_ADMIN_USER} -e INFLUXDB_ADMIN_PASSWORD=${INFLUXDB_ADMIN_PASSWORD} -v ${STACKDIR}/influxdb/db:/var/lib/influxdb ${influxdb_image} /init-influxdb.sh

echo "Compose up influxdb"
docker-compose -f docker-compose.yml up -d influxdb

echo "Creating admin user"
docker exec -it influxdb influx -execute "CREATE USER ${INFLUXDB_ADMIN_USER} WITH PASSWORD '${INFLUXDB_ADMIN_PASSWORD}' WITH ALL PRIVILEGES"

echo "Creating sensors DB"
docker exec -it influxdb influx  -username ${INFLUXDB_ADMIN_USER} -password "${INFLUXDB_ADMIN_PASSWORD}" -execute 'CREATE DATABASE sensors'

echo "Creating telegraf user"
docker exec -it influxdb influx -username ${INFLUXDB_ADMIN_USER} -password "${INFLUXDB_ADMIN_PASSWORD}"  -execute "USE sensors  
CREATE USER ${INFLUXDB_TELEGRAF_USER} WITH PASSWORD '${INFLUXDB_TELEGRAF_PASSWORD}'"

echo "Granting access to telegraf user"
docker exec -it influxdb influx -username ${INFLUXDB_ADMIN_USER} -password "${INFLUXDB_ADMIN_PASSWORD}"  -execute "USE sensors  
GRANT ALL on sensors TO telegraf"

echo "Show created databases"
curl -G http://localhost:8086/query  --data-urlencode "u=${INFLUXDB_ADMIN_USER}" --data-urlencode "p=${INFLUXDB_ADMIN_PASSWORD}" --data-urlencode "q=SHOW DATABASES"

echo "Compose down"
docker-compose -f docker-compose.yml down
