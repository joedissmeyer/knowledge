# Elastic Stack test lab

Creates the following hosts:

- elastic1 (192.168.56.111) -> Elasticsearch node 1, Master and Data roles
- elastic2 (192.168.56.112) -> Elasticsearch node 2, Master and Data roles
- elastic3 (192.168.56.113) -> Elasticsearch node 3, Master and Data roles
- kibana (192.168.56.114) -> Standalone Kibana node

Other notes: 

- Each VM in the project is configured for 2GB of RAM.
- Internal monitoring is enabled for the cluster.
- Filebeat, Auditbeat, and Metricbeat are installed.
- Still working on ansible playbooks to enable and start beats on each node.