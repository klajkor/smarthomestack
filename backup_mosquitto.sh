#!/bin/bash
#
# Mosquitto backup
#
SYSTEM_NAME = "mosquitto"
SOURCE_DIR ="${SYSTEM_NAME}/"
BACKUP_DIR = "./backup"
TIME_STAMP = `date "+%Y%m%d-%H%M%S"`
BACKUP_FILE = "${BACKUP_DIR}/${SYSTEM_NAME}_${TIME_STAMP}"
mdir -p $BACKUP_DIR
tar cvfz $BACKUP_FILE $SOURCE_DIR