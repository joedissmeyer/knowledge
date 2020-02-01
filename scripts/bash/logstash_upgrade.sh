#!/bin/bash

echo "#################################################"
echo "###   Logstash Install/Upgrade Script         ###"
echo "#################################################"
echo "###  Only for Logstash 6.x and 7.x versions   ###"
echo "#################################################"
echo " "
echo "Type version number to Upgrade: "

read version
RPMFILE="logstash-$version.rpm"

if [[ $version = 7* ]]
then
  DOWNLOAD="https://artifacts.elastic.co/downloads/logstash/$RPMFILE"
elif [[ $version = 6* ]]
then
  DOWNLOAD="https://artifacts.elastic.co/downloads/logstash/$RPMFILE"
else
  echo = "A proper version was not selected. Exiting script now."
  exit
fi

echo "------ Download Logstash ------"
wget $DOWNLOAD

echo "------ Stop Logstash ------"
service logstash stop

echo "------ Install/Update Open JDK from the RHEL repos ------"
yum -y install java-11-openjdk

echo "------ Update Logstash ------"
rpm --upgrade $RPMFILE

echo "------ Reload the service daemon ------"
systemctl daemon-reload

echo "------ Delete all old log files ------"
rm -rf /var/log/logstash/*.*

echo "------ Start the logstash service ------"
service logstash start

echo "------ Cleanup ------"
rm -rf $RPMFILE

echo "------ SCRIPT DONE!!! -------"