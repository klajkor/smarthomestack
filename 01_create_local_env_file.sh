#!/bin/bash
#
# Ccreate local env file
#
USER=`id -un`
USERID=`id -u`
#Docker group ID
GROUPID=`getent group docker | cut -d: -f3`
SUBDIR="smarthomestack"
STACKDIR=`pwd`

if [ -e .env ]
then
    TIMESTAMP=`date "+%Y%m%d-%H%M%S"`
    BACKUPFILE=".env_${TIMESTAMP}"
    echo "Backing up of old .env file to ${BACKUPFILE}"
    cp .env ${BACKUPFILE}
fi

echo "PUID=${USERID}
PGID=${GROUPID}
TZ=Europe/Budapest
USERDIR=/home/${USER}
STACKDIR=${STACKDIR}
COMPOSECOMMAND=\"docker compose\"
" > .env

echo "=> New .env file:"
cat .env
echo "-------------------"
