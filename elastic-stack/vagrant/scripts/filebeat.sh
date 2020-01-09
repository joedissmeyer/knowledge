#!/bin/bash

# Install Filebeat

wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.5.1-x86_64.rpm
sudo rpm --install filebeat-7.5.1-x86_64.rpm
sudo rm -rf filebeat-7.5.1-x86_64.rpm

# Configure Filebeat

sudo mkdir /var/log/filebeat
sudo rm -rf /etc/filebeat/filebeat.yml
sudo cat > /etc/filebeat/filebeat.yml <<'EOF'
#==========================  Modules configuration =============================
filebeat.modules:

#-------------------------------- System Module --------------------------------
#- module: system
  # Syslog
  #syslog:
    #enabled: true

    # Set custom paths for the log files. If left empty,
    # Filebeat will choose the paths depending on your OS.
    #var.paths:

    # Input configuration (advanced). Any input configuration option
    # can be added under this section.
    #input:

  # Authorization logs
  #auth:
    #enabled: true

    # Set custom paths for the log files. If left empty,
    # Filebeat will choose the paths depending on your OS.
    #var.paths:

    # Input configuration (advanced). Any input configuration option
    # can be added under this section.
    #input:


filebeat.config:
  modules:
    enabled: true
    path: modules.d/*.yml
    reload.enabled: true
    reload.period: 10s
output.elasticsearch:
  hosts: ["elasticmaster1:9200","elasticmaster2:9200","elasticmaster3:9200"]
setup.kibana:
  host: "kibana:5601"
logging.level: info
logging.to_files: true
logging.files:
  path: /var/log/filebeat
  name: filebeat.log
  keepfiles: 7
monitoring.enabled: true
monitoring.elasticsearch:
EOF

# Run Filebeat setup (index template, dashboards, ILM policy)

sudo filebeat setup
sudo mv /etc/filebeat/modules.d/system.yml.disabled /etc/filebeat/modules.d/system.yml

# Start Filebeat

sudo systemctl enable filebeat
sudo systemctl start filebeat

exit