#!/bin/bash

# Install Filebeat

wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.6.0-x86_64.rpm
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.6.0-x86_64.rpm.sha512
shasum -a 512 -c filebeat-7.6.0-x86_64.rpm.sha512
sudo rpm --install filebeat-7.6.0-x86_64.rpm
sudo rm -rf filebeat-7.6.0-x86_64.rpm

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
  hosts: ["elastic1:9200","elastic2:9200","elastic3:9200"]
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

exit