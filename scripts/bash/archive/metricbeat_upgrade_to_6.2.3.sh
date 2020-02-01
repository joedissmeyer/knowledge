#!/bin/bash

echo "------ Stopping Metricbeat -------"
systemctl stop metricbeat.service

echo "------ Download Metricbeat 6.2.3 RPM and Install ------"
wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-6.2.3-x86_64.rpm
rpm --upgrade metricbeat-6.2.3-x86_64.rpm

echo "------ Reload the service daemons ------"
systemctl daemon-reload

echo "------ Starting Metricbeat -------"
systemctl start metricbeat.service

echo "------ Cleanup -------"
rm -rf ./metricbeat-6.2.3-x86_64.rpm

echo "------ Script Done! ------"