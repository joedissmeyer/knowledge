#!/bin/bash

echo "1. Stop the Elasticsearch service and remove plugins."
service elasticsearch stop
/usr/share/elasticsearch/bin/elasticsearch-plugin remove x-pack
/usr/share/elasticsearch/bin/elasticsearch-plugin remove ingest-geoip
/usr/share/elasticsearch/bin/elasticsearch-plugin remove ingest-user-agent

echo "2. Remove the currently installed Oracle JDK RPM."
yum -y remove jdk1.8.0_73

echo "3. Install Open JDK from the RHEL repos."
yum -y install java-1.8.0-openjdk

echo "4. Download and Upgrade Elasticsearch"
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.1.3.rpm
rpm --upgrade elasticsearch-6.1.3.rpm

echo "5. Re-Install plugins"
echo "y" | /usr/share/elasticsearch/bin/elasticsearch-plugin install x-pack
echo "y" | /usr/share/elasticsearch/bin/elasticsearch-plugin install ingest-geoip
/usr/share/elasticsearch/bin/elasticsearch-plugin install ingest-user-agent

echo "7. Reload the service daemon."
systemctl daemon-reload

echo "8. Start the Elasticsearch service."
service elasticsearch start

echo "9. Cleanup"
rm -rf elasticsearch-6.1.3.rpm

echo "------ SCRIPT DONE!!! -------"
