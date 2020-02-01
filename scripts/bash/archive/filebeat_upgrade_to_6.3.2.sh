#!/bin/bash

echo "------ Stopping Filebeat -------"
systemctl stop filebeat.service

echo "------ Download Metricbeat 6.2.3 RPM and Install ------"
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.3.2-x86_64.rpm
rpm --upgrade filebeat-6.3.2-x86_64.rpm

echo "------ Reload the service daemons ------"
systemctl daemon-reload

echo "------ Starting Metricbeat -------"
systemctl start filebeat.service

echo "------ Cleanup -------"
rm -rf ./filebeat-6.2.3-x86_64.rpm

echo "------ Script Done! ------"