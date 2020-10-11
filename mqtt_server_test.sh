#!/bin/bash
#
# Test if MQTT server running
#
NETSTAT_MQTT=`netstat -an --tcp|grep -v '1883[0123456789]'|grep 1883|wc -l`
if [ $NETSTAT_MQTT -gt 0 ] ; then
  echo "MQTT server is running:"
  netstat -an --tcp|grep -v '1883[0123456789]'|grep 1883
else
  echo "WARNING: MQTT server is NOT running!"
fi