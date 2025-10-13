#!/bin/bash

sudo bash -c '
i=0
while true; do
    echo "{\"DateTime\":\"$(date)\", \"Level\":\"Info\", \"LogMessage\":\"This is demo log $i\", \"MachineName\":\"$(hostname)\", \"MachineIP\":\"$(hostname -i)\"}" >> /var/log/myapplication.log
    i=$((i + 1))
    sleep 1
done
'