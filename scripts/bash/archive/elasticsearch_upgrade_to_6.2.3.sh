#!/bin/bash

echo "------ Stopping Elasticsearch -------"
service elasticsearch stop

echo "------ Remove Elasticsearch plugins -------"
/usr/share/elasticsearch/bin/elasticsearch-plugin remove x-pack
/usr/share/elasticsearch/bin/elasticsearch-plugin remove ingest-geoip
/usr/share/elasticsearch/bin/elasticsearch-plugin remove ingest-user-agent

echo "------ Remove the Oracle JDK if installed ------"
yum -y remove jdk1.8.0_73

echo "------ Install or Update OpenJDK ------"
yum -y install java-1.8.0-openjdk

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

echo "------ Final Cleanup -------"
rm -rf ./elasticsearch-6.2.3.rpm

echo "------ SCRIPT DONE!!! -------"
