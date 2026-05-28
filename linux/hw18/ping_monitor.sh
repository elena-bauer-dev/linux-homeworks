#!/bin/bash

SERVER=$1

if [ -z "$SERVER" ]; then
echo "Usage: ./ping_monitor.sh <host>"
exit 1

fi

failed_count=0

while true
do

ping_result=$(ping -c 1 "$SERVER")

if [ $? -eq 0 ]; then
failed_count=0
time_ms=$(echo "$ping_result" | grep "time=" | sed -E 's/.*time=([0-9.]+).*/\1/')
echo "Ping: ${time_ms} ms"
time_int=${time_ms%.*}

if [ "$time_int" -gt 100 ]; then
echo "WARNING: Ping is higher than 100 ms!"
fi

else
failed_count=$((failed_count + 1))
echo "Connection failed! Failed attempts: $failed_count"
if [ "$failed_count" -ge 3 ]; then
echo "ERROR: Host is down for 3 attempts!"
fi

fi

sleep 1

done
