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

vi /etc/consul.d/bootstrap/server.json

```
{
    "server": true,
    "datacenter": "main",
    "data_dir": "/opt/consul",
    "encrypt": "JOz5Sc22LDgQgmGwEe864ESqkri4vsMCA8c6s86pDqE=",
    "bootstrap_expect": 1,
    "ui": true,
    "log_level": "INFO",
    "start_join": [
        "192.168.56.102",
        "192.168.56.103"
    ],
    "client_addr": "0.0.0.0"
}
```