#!/bin/bash

yum -y install wget unzip

sudo useradd -r consul

sudo mkdir -p /etc/consul.d/{bootstrap,server,client}
sudo mkdir /var/consul
sudo mkdir /opt/consul
sudo chown -R consul:consul /var/consul
sudo chown -R consul:consul /opt/consul
cd /usr/local/bin
sudo wget https://releases.hashicorp.com/consul/1.6.1/consul_1.6.1_linux_amd64.zip
sudo unzip consul_1.6.1_linux_amd64.zip
sudo rm -rf consul_1.6.1_linux_amd64.zip