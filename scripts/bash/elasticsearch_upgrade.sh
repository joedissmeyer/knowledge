#!/bin/bash

echo "#################################################"
echo "### Elasticsearch Install/Upgrade Script  ###"
echo "#################################################"
echo "###      Only for ES 6.x and 7.x versions     ###"
echo "#################################################"
echo " "
echo "Type version number to Upgrade: "

read version

if [[ $version = 7* ]]
then
  RPMFILE="elasticsearch-$version-x86_64.rpm"
  DOWNLOAD="https://artifacts.elastic.co/downloads/elasticsearch/$RPMFILE"
elif [[ $version = 6* ]]
then
  RPMFILE="elasticsearch-$version.rpm"
  DOWNLOAD="https://artifacts.elastic.co/downloads/elasticsearch/$RPMFILE"
else
  echo = "A proper version was not selected. Exiting script now."
  exit
fi


echo "------ Download Elasticsearch $version RPM -------"
wget $DOWNLOAD

echo "------ Stopping Elasticsearch -------"
service elasticsearch stop

echo "------ Install/Update Open JDK ------"
remove -y remove java-1.8.0-openjdk
yum -y install java-11-openjdk

echo "------ Install Elasticsearch $version RPM -------"
rpm --upgrade $RPMFILE

echo "------ Fix Elasticsearch directory permissions -------"
chown -R elasticsearch:elasticsearch /etc/elasticsearch/
chown -R elasticsearch:elasticsearch /var/log/elasticsearch/

echo "------ Reload the Elasticsearch service daemon ------"
systemctl daemon-reload

echo "------ Starting Elasticsearch -------"
service elasticsearch start

echo "------ Final Cleanup -------"
rm -rf ./$RPMFILE

echo "------ SCRIPT DONE!!! -------"