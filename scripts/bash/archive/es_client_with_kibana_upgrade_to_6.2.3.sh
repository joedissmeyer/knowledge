#!/bin/bash

echo "------ Stopping Kibana -------"
systemctl stop kibana.service

echo "------ Removing X-Pack Plugin from Kibana ------"
/usr/share/kibana/bin/kibana-plugin remove x-pack

echo "------ Stopping Elasticsearch -------"
service elasticsearch stop

echo "------ Remove Elasticsearch plugins -------"
/usr/share/elasticsearch/bin/elasticsearch-plugin remove x-pack
/usr/share/elasticsearch/bin/elasticsearch-plugin remove ingest-geoip
/usr/share/elasticsearch/bin/elasticsearch-plugin remove ingest-user-agent

echo "------ Download Elasticsearch 6.2.3 RPM -------"
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.3.rpm

echo "------ Install Elasticsearch 6.2.3 RPM -------"
rpm --upgrade elasticsearch-6.2.3.rpm

echo "------ Install Elasticsearch plugins -------"
echo "y" | /usr/share/elasticsearch/bin/elasticsearch-plugin install x-pack
echo "y" | /usr/share/elasticsearch/bin/elasticsearch-plugin install ingest-geoip
/usr/share/elasticsearch/bin/elasticsearch-plugin install ingest-user-agent

echo "------ Reload the Elasticsearch service daemon ------"
systemctl daemon-reload

echo "------ Starting Elasticsearch -------"
service elasticsearch start

echo "------ Download Kibana 6.2.3 RPM ------"
wget https://artifacts.elastic.co/downloads/kibana/kibana-6.2.3-x86_64.rpm

echo "------ Install Kibana 6.2.3 from RPM ------"
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

echo "------ Final Cleanup -------"
rm -rf ./elasticsearch-6.2.3.rpm
rm -rf ./kibana-6.2.3-x86_64.rpm

echo "Script Done!"
