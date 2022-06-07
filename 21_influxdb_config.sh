#!/bin/bash
#
# Initial config of Influxdb
#

echo "=> Initial config of Influxdb started"

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

# ${STACKDIR} is from .env
cd ${STACKDIR}

influxdb_image=`grep "image: influxdb" docker-compose.yml | awk -F":" '{print $2":"$3}'`

${COMPOSECOMMAND} -f docker-compose.yml down

echo "Creating influxdb.conf for image ${influxdb_image}"
docker run --rm -p 8086:8086 ${influxdb_image} influxd config > ${STACKDIR}/influxdb/influxdb.conf
read -p "=> Press any key to continue"

echo "Changing influxdb.conf file"
sed -i 's/^\(  auth-enabled\s*=\s*\).*$/\1true/' ${STACKDIR}/influxdb/influxdb.conf
sudo chown -R ${USER}:docker ${STACKDIR}/influxdb/influxdb.conf
read -p "=> Press any key to continue"

echo "Init influxdb"
docker run --rm -e INFLUXDB_ADMIN_USER=${INFLUXDB_ADMIN_USER} -e INFLUXDB_ADMIN_PASSWORD=${INFLUXDB_ADMIN_PASSWORD} -v ${STACKDIR}/influxdb/db:/var/lib/influxdb ${influxdb_image} /init-influxdb.sh
read -p "=> Press any key to continue"

echo "Compose up influxdb"
${COMPOSECOMMAND} -f docker-compose.yml up -d influxdb
read -p "=> Press any key to continue"
echo "Waiting for 2 sec"
sleep 2

echo "Show users"
${COMPOSECOMMAND} exec -it influxdb influx  -username ${INFLUXDB_ADMIN_USER} -password "${INFLUXDB_ADMIN_PASSWORD}" -execute 'SHOW USERS'
read -p "=> Press any key to continue"

#Not needed for now
#echo "Creating admin user"
#${COMPOSECOMMAND} exec -it influxdb influx -execute "CREATE USER ${INFLUXDB_ADMIN_USER} WITH PASSWORD '${INFLUXDB_ADMIN_PASSWORD}' WITH ALL PRIVILEGES"
#read -p "=> Press any key to continue"

echo "Creating sensors DB"
${COMPOSECOMMAND} exec -it influxdb influx  -username ${INFLUXDB_ADMIN_USER} -password "${INFLUXDB_ADMIN_PASSWORD}" -execute 'CREATE DATABASE sensors'
read -p "=> Press any key to continue"

echo "Creating telegraf user"
${COMPOSECOMMAND} exec -it influxdb influx -username ${INFLUXDB_ADMIN_USER} -password "${INFLUXDB_ADMIN_PASSWORD}"  -execute "USE sensors  
CREATE USER ${INFLUXDB_TELEGRAF_USER} WITH PASSWORD '${INFLUXDB_TELEGRAF_PASSWORD}'"
read -p "=> Press any key to continue"

echo "Granting access to telegraf user"
${COMPOSECOMMAND} exec -it influxdb influx -username ${INFLUXDB_ADMIN_USER} -password "${INFLUXDB_ADMIN_PASSWORD}"  -execute "USE sensors  
GRANT ALL on sensors TO telegraf"
read -p "=> Press any key to continue"

echo "Show created databases"
curl -G http://localhost:8086/query  --data-urlencode "u=${INFLUXDB_ADMIN_USER}" --data-urlencode "p=${INFLUXDB_ADMIN_PASSWORD}" --data-urlencode "q=SHOW DATABASES"
read -p "=> Press any key to continue"

echo "Compose down"
${COMPOSECOMMAND} -f docker-compose.yml down

echo "=> Initial config of Influxdb completed"