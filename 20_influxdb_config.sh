#!/bin/bash
#
# Initial config of Influxdb
#
docker run --rm -p 8086:8086 influxdb influxd config > ~/smarthomestack/influxdb/influxdb.conf 

set -o allexport
source influxdb.env
set +o allexport

echo $INFLUXDB_ADMIN_USER
echo $INFLUXDB_ADMIN_PASSWORD
