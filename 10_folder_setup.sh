#!/bin/bash
#
# Folder setup
#
USER=`id -un`
mkdir -p ~/smarthomestack
sudo setfacl -Rdm g:docker:rwx ~/smarthomestack
sudo chmod -R 775 ~/smarthomestack
mkdir -p ~/smarthomestack/shared
mkdir -p ~/smarthomestack/portainer/data
mkdir -p ~/smarthomestack/mosquitto/config
mkdir -p ~/smarthomestack/mosquitto/data
mkdir -p ~/smarthomestack/mosquitto/log
mkdir -p ~/smarthomestack/homeassistant
mkdir -p ~/smarthomestack/grafana
mkdir -p ~/smarthomestack/postgresql/data
mkdir -p ~/smarthomestack/mariadb/data
mkdir -p ~/smarthomestack/adminer
mkdir -p ~/smarthomestack/influxdb/db
mkdir -p ~/smarthomestack/telegraf

cd ~/smarthomestack
find . -type d -exec touch {}/.gitignore \;

touch ~/smarthomestack/mosquitto/config/mosquitto.conf
touch ~/smarthomestack/mosquitto/config/passwd
touch ~/smarthomestack/mosquitto/log/mosquitto.log
touch ~/smarthomestack/influxdb/influxdb.conf
touch ~/smarthomestack/telegraf/telegraf.conf
sudo setfacl -Rdm g:docker:rwx ~/smarthomestack
sudo chmod -R 775 ~/smarthomestack
sudo chmod -R ug+rw ~/smarthomestack
sudo chmod -R o+r ~/smarthomestack
sudo chown -R ${USER}:docker ~/smarthomestack

