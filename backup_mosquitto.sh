#!/bin/bash
#
# Mosquitto backup
#
SYSTEMNAME="mosquitto"
SOURCEDIR="${SYSTEMNAME}/"
BACKUPDIR="./backup"
TIMESTAMP=`date "+%Y%m%d-%H%M%S"`
BACKUPFILE="${BACKUPDIR}/${SYSTEMNAME}_${TIMESTAMP}.tar.gz"
mkdir -p $BACKUPDIR
tar cvfz $BACKUPFILE $SOURCEDIR