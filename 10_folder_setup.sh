#!/bin/bash
#
# Folder setup
#

echo "=> Folder setup started"
USER=`id -un`

if [ ! -e .env ]
then
    echo "<!> Please create proper .env file! Exiting."
    exit 1
fi

set -o allexport
source .env
set +o allexport

# ${STACKDIR} is from .env
cd ${STACKDIR}

echo "Stack directory: ${STACKDIR}"
mkdir -p ${STACKDIR}
sudo chown -R ${USER}:docker ${STACKDIR}
echo "Creating subdirs under ${STACKDIR}"
mkdir -p ${STACKDIR}/shared
mkdir -p ${STACKDIR}/portainer/data
mkdir -p ${STACKDIR}/mosquitto/config
mkdir -p ${STACKDIR}/mosquitto/data
mkdir -p ${STACKDIR}/mosquitto/log
mkdir -p ${STACKDIR}/homeassistant
mkdir -p ${STACKDIR}/grafana
mkdir -p ${STACKDIR}/influxdb/db
mkdir -p ${STACKDIR}/telegraf

# mkdir -p ${STACKDIR}/postgresql/data
# mkdir -p ${STACKDIR}/mariadb/data
# mkdir -p ${STACKDIR}/adminer


cd ${STACKDIR}
##find . -type d -exec touch {}/.gitignore \;
if [ -e ${STACKDIR}/mosquitto/log/.gitignore ]
then
    rm ${STACKDIR}/mosquitto/log/.gitignore
fi
echo "Creating some files under ${SUBDIR}"
touch ${STACKDIR}/mosquitto/config/mosquitto.conf
touch ${STACKDIR}/mosquitto/config/passwd
touch ${STACKDIR}/mosquitto/log/mosquitto.log
touch ${STACKDIR}/influxdb/influxdb.conf
touch ${STACKDIR}/telegraf/telegraf.conf
# for accessing telegraf log from outside
touch ${STACKDIR}/telegraf/telegraf.log
echo "Setting file permissions"
sudo chown -R ${USER}:docker ${STACKDIR}
sudo setfacl -Rdm g:docker:rw ${STACKDIR}
sudo chmod -R ug+rw ${STACKDIR}
sudo chmod -R o+r ${STACKDIR}
sudo chmod -R ugo+x ${STACKDIR}/*.sh
sudo chmod -R ugo-x ${STACKDIR}/mosquitto/log/mosquitto.log
sudo chmod -R ugo-x ${STACKDIR}/telegraf/telegraf.log
#sudo chmod -R ugo-x,ugo+X ${STACKDIR}
#echo "Setting specific mosquitto file permissions"
#sudo chgrp -R ${PGID} ${STACKDIR}/mosquitto
#sudo setfacl -Rdm u:${PUID}:rw ${STACKDIR}/mosquitto
#sudo setfacl -Rdm g:${PGID}:rw ${STACKDIR}/mosquitto

echo "=> Folder setup completed"