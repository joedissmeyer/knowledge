#!/bin/bash

echo "1. Stop Logstash and remove the X-Pack plugin."
service logstash stop
/usr/share/logstash/bin/logstash-plugin remove x-pack

echo "2. Remove the currently installed Oracle JDK RPM."
yum -y remove jdk1.8.0_73

echo "3. Install Open JDK from the RHEL repos."
yum -y install java-1.8.0-openjdk

echo "4. Update Logstash"
wget https://artifacts.elastic.co/downloads/logstash/logstash-6.1.3.rpm
rpm --upgrade logstash-6.1.3.rpm

echo "5. Re-install x-pack"
/usr/share/logstash/bin/logstash-plugin install x-pack

echo "6. Reload the service daemon."
systemctl daemon-reload

echo "7. Delete all old log files."
rm -rf /var/log/logstash/*.*

echo "8. Start the logstash service."
service logstash start

echo "9. Cleanup."
rm -rf logstash-6.1.3.rpm

echo "------ SCRIPT DONE!!! -------"
