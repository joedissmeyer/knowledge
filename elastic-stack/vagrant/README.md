# Elastic Stack test lab

*Updated on 2020-01-21 for Elastic Stack release v7.5.1.*

Creates the following hosts:

- elastic1 (192.168.56.111) -> Elasticsearch node 1, Master and Data roles
- elastic2 (192.168.56.112) -> Elasticsearch node 2, Master and Data roles
- elastic3 (192.168.56.113) -> Elasticsearch node 3, Master and Data roles
- kibana (192.168.56.114) -> Standalone Kibana node
- logstash (192.168.56.115) -> Single Logstash node

The logstash host will be used as the Ansible control node.

Also, this test lab uses the "Basic License" for the Elastic Stack so monitoring, SIEM, Maps, and other standard licensed features can be tested.
So regarding licensing each node is licensed using the Elastic Basic license (already enabled by default thanks to the out-of-the-box config).

Other notes: 

- Each VM in the project is configured to consume 2GB of RAM. 8GB of dedicated RAM is required to run this lab.
- Internal monitoring is enabled for the cluster.
- Filebeat, Auditbeat, and Metricbeat are installed.
- Still working on ansible playbooks to enable and start beats on each node.