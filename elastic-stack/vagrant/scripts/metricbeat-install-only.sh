#!/bin/bash

# Install Metricbeat

wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.5.1-x86_64.rpm
sudo rpm --install metricbeat-7.5.1-x86_64.rpm
sudo rm -rf metricbeat-7.5.1-x86_64.rpm

# Configure Metricbeat

sudo mkdir /var/log/metricbeat
sudo rm -rf /etc/metricbeat/metricbeat.yml
sudo cat > /etc/metricbeat/metricbeat.yml <<'EOF'
metricbeat.config.modules:
  path: ${path.config}/modules.d/*.yml
setup.template.overwrite: true
setup.template.enabled: true
setup.template.settings:
  index.number_of_shards: 1
  index.codec: best_compression
setup.dashboards.enabled: true
setup.kibana:
  host: "kibana:5601"
output.elasticsearch:
  hosts: ["elastic1:9200","elastic2:9200","elastic3:9200"]
logging.level: info
logging.to_files: true
logging.files:
  path: /var/log/metricbeat
  name: metricbeat.log
  keepfiles: 7
monitoring.enabled: true
monitoring.elasticsearch:

EOF

exit