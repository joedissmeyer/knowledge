# Apache Kafka Configuration Example

This repository contains the configurations of the Apache Kafka instances.

## Information

Kafka is being used as a high performance message queue for the Elastic Stack instances.

It is intended to be both a data buffer for Logstash, as well as a temporary log store in the event of a Logstash or Elasticsearch cluster outage.

Current architecture design is for three nodes, all members of the same cluster.

Partition replication occurs automatically at topic creation (provided the partition value of `3` is chosen).

## Vagrant

To stand up a quick test lab for a 3 node Kafka cluster check the provided Vagrantfile in the `./vagrant` directory.

Server 1: kakfa1 (192.168.56.101)
Server 2: kafka2 (192.168.56.102)
Server 3: kafka3 (192.168.56.102)

Assumes VirtualBox is the virtualization platform of choice.

Each VM is configured for the following: 
1 vCPU
1GB RAM
Standard `centos/7` vagrant box image
