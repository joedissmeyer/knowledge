#!/bin/bash

echo "------ Stopping Kibana -------"
systemctl stop kibana.service

echo "------ Removing X-Pack Plugin from Kibana ------"
/usr/share/kibana/bin/kibana-plugin remove x-pack

echo "------ Download Kibana 6.2.3 RPM and Install ------"
wget https://artifacts.elastic.co/downloads/kibana/kibana-6.2.3-x86_64.rpm
rpm --upgrade kibana-6.2.3-x86_64.rpm

echo "------ Copy Custom Kibana Logo -------"
echo "yes" | cp /etc/scripts/kibana_*.svg /usr/share/kibana/src/ui/public/images/kibana.svg

echo "------ Fix directory permissions ------"
chown -R kibana:kibana /usr/share/kibana/

echo "------ Install Kibana X-Pack Plugin ------"
sudo -u kibana /usr/share/kibana/bin/kibana-plugin install x-pack

echo "------ Reload the Kibana service daemon ------"
systemctl daemon-reload

echo "------ Starting Kibana -------"
systemctl start kibana.service

echo "------ Cleanup -------"
rm -rf ./kibana-6.2.3-x86_64.rpm

echo "------ Script Done! ------"
