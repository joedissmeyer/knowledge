# Apache Kafka Configuration Example

This repository contains the configurations of the Apache Kafka instances.

## Information

Kafka is being used as a high performance message queue for the Elastic Stack instances.

It is intended to be both a data buffer for Logstash, as well as a temporary log store in the event of a Logstash or Elasticsearch cluster outage.

Current architecture design is for three nodes, all members of the same cluster.

Partition replication occurs automatically at topic creation (provided the partition value of `3` is chosen).

## Vagrant

To stand up a quick test lab for a 3 node Kafka cluster check the provided Vagrantfile in the `./vagrant` directory.
