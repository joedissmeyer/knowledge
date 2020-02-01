#!/bin/bash

echo "Enter Version number to Upgrade: "

read version

echo "------ Download Heartbeat $version RPM -------"
wget https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$version-x86_64.rpm

echo "------ Stopping Heartbeat -------"
service heartbeat-elastic stop

echo "------ Install Heartbeat $version RPM -------"
rpm --upgrade heartbeat-$version-x86_64.rpm

echo "------ Reload the service daemon ------"
systemctl daemon-reload

echo "------ Starting Heartbeat -------"
service heartbeat-elastic start

echo "------ Final Cleanup -------"
rm -rf ./heartbeat-$version-x86_64.rpm

echo "------ SCRIPT DONE!!! -------"