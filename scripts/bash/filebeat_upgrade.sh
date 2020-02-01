#!/bin/bash

echo "Enter Filebeat Version number to Upgrade: "

read version

echo "------ Download Filebeat $version RPM -------"
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$version-x86_64.rpm

echo "------ Stopping Filebeat -------"
service filebeat stop

echo "------ Install Filebeat $version -------"
rpm --upgrade filebeat-$version-x86_64.rpm

echo "------ Reload the systemd service daemon ------"
systemctl daemon-reload

echo "------ Start Filebeat -------"
service filebeat start

echo "------ Final Cleanup -------"
rm -rf ./filebeat-$version-x86_64.rpm

echo "------ SCRIPT DONE!!! -------"