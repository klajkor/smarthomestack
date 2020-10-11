#!/bin/bash
#
# Test if MQTT service running
#
echo "########################################"
echo "### Testing MQTT Service"
NETSTAT_MQTT=`netstat -an --tcp|grep -v '1883[0123456789]'|grep 1883|wc -l`
if [ $NETSTAT_MQTT -gt 0 ] ; then
  echo "MQTT service is running:"
  netstat -an --tcp|grep -v '1883[0123456789]'|grep 1883
  ps -fl -C mosquitto
else
  echo "WARNING: MQTT service is NOT running!"
  ps -fl -C mosquitto
fi