#!/bin/bash

# Install Auditbeat

wget https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-7.5.1-x86_64.rpm
sudo rpm --install auditbeat-7.5.1-x86_64.rpm
sudo rm -rf auditbeat-7.5.1-x86_64.rpm

# Configure Auditbeat

sudo mkdir /var/log/auditbeat
sudo rm -rf /etc/auditbeat/auditbeat.yml
sudo cat > /etc/auditbeat/auditbeat.yml <<'EOF'
auditbeat.modules:
- module: auditd
  audit_rules: |
    -w /etc/passwd -p wa -k identity
    -a always,exit -F arch=b32 -S open,creat,truncate,ftruncate,openat,open_by_handle_at -F exit=-EPERM -k access
- module: system
  datasets:
    - host
    - login
    - package
    - process
    - socket
    - user
  period: 10s
  state.period: 12h
  socket.include_localhost: false
  user.detect_password_changes: true

output.elasticsearch:
  hosts: ["elasticmaster1:9200","elasticmaster2:9200","elasticmaster3:9200"]
setup.kibana:
  host: "kibana:5601"
logging.level: info
logging.to_files: true
logging.files:
  path: /var/log/auditbeat
  name: auditbeat.log
  keepfiles: 7
monitoring.enabled: true
monitoring.elasticsearch:
EOF

exit