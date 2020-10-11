#!/bin/bash
#
# Folder setup
#
USER=`id -un`
SUBDIR="smarthomestack"

cd ~
mkdir -p ~/${SUBDIR}
sudo setfacl -Rdm g:docker:rwx ~/${SUBDIR}
sudo chmod -R 775 ~/${SUBDIR}
mkdir -p ~/${SUBDIR}/shared
mkdir -p ~/${SUBDIR}/portainer/data
mkdir -p ~/${SUBDIR}/mosquitto/config
mkdir -p ~/${SUBDIR}/mosquitto/data
mkdir -p ~/${SUBDIR}/mosquitto/log
mkdir -p ~/${SUBDIR}/homeassistant
mkdir -p ~/${SUBDIR}/grafana
mkdir -p ~/${SUBDIR}/postgresql/data
mkdir -p ~/${SUBDIR}/mariadb/data
mkdir -p ~/${SUBDIR}/adminer
mkdir -p ~/${SUBDIR}/influxdb/db
mkdir -p ~/${SUBDIR}/telegraf

cd ~/${SUBDIR}
##find . -type d -exec touch {}/.gitignore \;
if [ -e ~/${SUBDIR}/mosquitto/log/.gitignore ]
then
    rm ~/${SUBDIR}/mosquitto/log/.gitignore
fi

touch ~/${SUBDIR}/mosquitto/config/mosquitto.conf
touch ~/${SUBDIR}/mosquitto/config/passwd
touch ~/${SUBDIR}/mosquitto/log/mosquitto.log
touch ~/${SUBDIR}/influxdb/influxdb.conf
touch ~/${SUBDIR}/telegraf/telegraf.conf
# for accessing telegraf log from outside
touch ~/${SUBDIR}/telegraf/telegraf.log
sudo setfacl -Rdm g:docker:rwx ~/${SUBDIR}
sudo chmod -R 775 ~/${SUBDIR}
sudo chmod -R ugo-x,ugo+X ~/${SUBDIR}
sudo chmod -R ugo+x ~/${SUBDIR}/*.sh
sudo chown -R ${USER}:docker ~/${SUBDIR}

