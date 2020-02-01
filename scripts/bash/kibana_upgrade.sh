#!/bin/bash

echo "#################################################"
echo "###     Kibana Install/Upgrade Script         ###"
echo "#################################################"
echo "###    Only for Kibana 6.x and 7.x versions   ###"
echo "#################################################"
echo " "
echo "Type version number to Upgrade: "

read version
RPMFILE="kibana-$version-x86_64.rpm"

if [[ $version = 7* ]]
then
  DOWNLOAD="https://artifacts.elastic.co/downloads/kibana/$RPMFILE"
elif [[ $version = 6* ]]
then
  DOWNLOAD="https://artifacts.elastic.co/downloads/kibana/$RPMFILE"
else
  echo = "A proper version was not selected. Exiting script now."
  exit
fi

echo "------ Download Kibana $version RPM ------"
wget $DOWNLOAD

echo "------ Stopping Kibana -------"
systemctl stop kibana.service

echo "------ Install Kibana $version ------"
rpm --upgrade $RPMFILE

echo "------ Delete logs -------"
rm -rf /var/log/kibana/kibana.log

echo "------ Fix directory permissions ------"
chown -R kibana:kibana /usr/share/kibana/

echo "------ Reload the Kibana service daemon ------"
systemctl daemon-reload

echo "------ Starting Kibana -------"
systemctl start kibana.service

echo "------ Cleanup -------"
rm -rf ./$RPMFILE

echo "------ Script Done! ------"