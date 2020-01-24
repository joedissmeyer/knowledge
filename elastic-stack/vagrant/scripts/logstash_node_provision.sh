#!/bin/bash

# Colorize bash shell. Makes sysadmin life easier.

cat > /etc/profile.d/colorbashshell.sh <<'EOF'
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[1;33m\]"
BLUE="\[\033[0;34m\]"
PURPLE="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"
WHITE="\[\033[1;37m\]"
RESET="\[\033[0m\]"

if [ $(id -u) -eq 0 ];
then # you are root, set red colour prompt
PS1="[$RED\u$RESET$CYAN@\h$RESET$PURPLE \W$RESET]\$ "
else # normal
PS1="[$GREEN\u$RESET$CYAN@\h$RESET$PURPLE \W$RESET]\$ "
fi
EOF

# Add hosts in project to local hosts file (for DNS resolution)
sudo echo '192.168.56.111 elastic1 elastic1' >> /etc/hosts
sudo echo '192.168.56.112 elastic2 elastic2' >> /etc/hosts
sudo echo '192.168.56.113 elastic3 elastic3' >> /etc/hosts
sudo echo '192.168.56.114 kibana kibana' >> /etc/hosts
sudo echo '192.168.56.115 logstash logstash' >> /etc/hosts

# Install OpenJRE 11 and wget

sudo yum -y install java-11-openjdk wget

# Download and install Logstash, clean up downloaded file

wget https://artifacts.elastic.co/downloads/logstash/logstash-7.5.2.rpm
wget https://artifacts.elastic.co/downloads/logstash/logstash-7.5.2.rpm.sha512
shasum -a 512 -c logstash-7.5.2.rpm.sha512
sudo rpm --install logstash-7.5.2.rpm
sudo rm -rf logstash-7.5.2.rpm

# Configure Logstash

sudo rm -rf /etc/logstash/logstash.yml
sudo cat > /etc/logstash/logstash.yml <<'EOF'
http.host: "0.0.0.0"
http.port: 9600-9700
path.logs: /var/log/logstash
xpack.monitoring.enabled: true
xpack.monitoring.elasticsearch.hosts: [ "http://elastic1:9200" ]
EOF

# Write initial Logstash pipeline for Beats

sudo cat > /etc/logstash/conf.d/beats.conf <<'EOF'
input {
    beats {
        port => 5044
    }
}
filter {}
output {
    elasticsearch {
        hosts => [ "http://elastic1:9200", "http://elastic2:9200", "http://elastic3:9200" ]
    }
}
EOF

# Update pipeline.yml file

rm -rf /etc/logstash/pipelines.yml
sudo cat > /etc/logstash/pipelines.yml <<'EOF'
- pipeline.id: beats
  path.config: "/etc/logstash/conf.d/beats.conf"
EOF

# Reload system units

sudo systemctl daemon-reload

# Start Logstash

#sudo systemctl start elasticsearch.service

# ANSIBLE SECTION --- UNDER CONSTRUCTION

exit