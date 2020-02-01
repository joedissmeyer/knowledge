#!/bin/bash

echo "------ Stop Logstash and remove the X-Pack plugin ------"
service logstash stop
/usr/share/logstash/bin/logstash-plugin remove x-pack

echo "------ Remove the currently installed Oracle JDK RPM ------"
yum -y remove jdk1.8.0_73

echo "------ Install Open JDK from the RHEL repos ------"
yum -y install java-1.8.0-openjdk

echo "------ Update Logstash ------"
wget https://artifacts.elastic.co/downloads/logstash/logstash-6.2.3.rpm
rpm --upgrade logstash-6.2.3.rpm

echo "------ Re-install x-pack ------"
/usr/share/logstash/bin/logstash-plugin install x-pack

echo "------ Reload the service daemon ------"
systemctl daemon-reload

echo "------ Delete all old log files ------"
rm -rf /var/log/logstash/*.*

echo "------ Start the logstash service ------"
service logstash start

echo "------ Cleanup ------"
rm -rf logstash-6.2.3.rpm

echo "------ SCRIPT DONE!!! -------"
