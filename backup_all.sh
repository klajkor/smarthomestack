#!/bin/bash
#
# Backup all sub-systems
#
echo "${0} Backup for all sub-systems"
SYSTEMS="grafana homeassistant influxdb mosquitto telegraf"
for SYSTEMNAME in $SYSTEMS
do
    echo "==>"
    echo "Creating backup for ${SYSTEMNAME}"
    SOURCEDIR="${SYSTEMNAME}/"
    BACKUPDIR="./backup"
    TIMESTAMP=`date "+%Y%m%d-%H%M%S"`
    BACKUPFILE="${BACKUPDIR}/${SYSTEMNAME}_${TIMESTAMP}.tar.gz"
    mkdir -p $BACKUPDIR
    tar cvfz $BACKUPFILE $SOURCEDIR
    echo "Backup finished, backup file created:"
    file $BACKUPFILE
    echo "###"
done