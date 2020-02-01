#!/bin/bash
# This script updates Consul from v1.5.3 to 1.6.0

echo "------ Stop Consul ------"
service consul stop

echo "------ Copy and backup old Consul executable ------"
mkdir /var/consul/backup/
mv /usr/local/bin/consul /var/consul/backup/consul_1.5.3_backup

echo "------ Download new Consul 1.4.0 package and extract ------"
cd /usr/local/bin
wget https://releases.hashicorp.com/consul/1.6.0/consul_1.6.0_linux_amd64.zip
unzip consul_1.6.0_linux_amd64.zip
rm -rf consul_1.6.0_linux_amd64.zip

echo "------ Reload the service daemon ------"
systemctl daemon-reload

echo "------ Start the logstash service ------"
service consul start

echo "------ SCRIPT DONE!!! -------"

# To check the consul version execute:
# consul --version

# To run consul manually, execute this
# /bin/bash -c '/usr/local/bin/consul agent -config-dir /etc/consul.d/server'