#!/bin/bash
#
# Initial config of Telegraf
#

cd ~/smarthomestack

set -o allexport
source influxdb.env
set +o allexport

docker run --rm telegraf telegraf config > ~/smarthomestack/telegraf/telegraf.conf

docker-compose -f docker-compose.yml up -d telegraf

docker-compose -f docker-compose.yml down