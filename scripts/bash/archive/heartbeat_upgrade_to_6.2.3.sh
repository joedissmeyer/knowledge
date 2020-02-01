#!/bin/bash

echo "------ Stopping Heartbeat -------"
service heartbeat-elastic stop

echo "------ Download Heartbeat 6.2.3 RPM -------"
wget https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-6.2.3-x86_64.rpm

echo "------ Install Heartbeat 6.2.3 RPM -------"
rpm --upgrade heartbeat-6.2.3-x86_64.rpm

echo "------ Reload the service daemon ------"
systemctl daemon-reload

echo "------ Starting Heartbeat -------"
service heartbeat-elastic start

echo "------ Final Cleanup -------"
rm -rf ./heartbeat-6.2.3-x86_64.rpm

echo "------ SCRIPT DONE!!! -------"
