#!/bin/bash
#
# Test if Telegraf service running
#
echo "########################################"
echo "### Testing Telegraf Service"
PS_TELEGRAF=`ps -fl --noheader -C telegraf|wc -l`
if [ $PS_TELEGRAF -gt 0 ] ; then
  echo "Telegraf service is running:"
  ps -fl -C telegraf
else
  echo "WARNING: Telegraf service is NOT running!"
fi