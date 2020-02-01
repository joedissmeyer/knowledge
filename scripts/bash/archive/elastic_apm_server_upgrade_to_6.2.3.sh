#!/bin/bash

echo "------ Stopping Elasticsearch -------"
service apm-server stop

echo "------ Download Elastic APM Server -------"
wget https://artifacts.elastic.co/downloads/apm-server/apm-server-6.2.3-x86_64.rpm

echo "------ Install Elastic APM Server -------"
rpm --upgrade apm-server-6.2.3-x86_64.rpm

echo "------ Reload the service daemon ------"
systemctl daemon-reload

echo "------ Starting Elastic APM Server -------"
service apm-server start

echo "------ Final Cleanup -------"
rm -rf ./apm-server-6.2.3-x86_64.rpm

echo "------ SCRIPT DONE!!! -------"
