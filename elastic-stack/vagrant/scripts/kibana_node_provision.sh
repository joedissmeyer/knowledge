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
sudo echo '192.168.56.111 elasticmaster1 elasticmaster1' >> /etc/hosts
sudo echo '192.168.56.112 elasticmaster2 elasticmaster2' >> /etc/hosts
sudo echo '192.168.56.113 elasticmaster3 elasticmaster3' >> /etc/hosts
sudo echo '192.168.56.114 kibana kibana' >> /etc/hosts
sudo echo '192.168.56.114 logstash logstash' >> /etc/hosts

# Install wget

sudo yum -y install wget

# Download and install Kibana

wget https://artifacts.elastic.co/downloads/kibana/kibana-7.5.1-x86_64.rpm
sudo rpm --install kibana-7.5.1-x86_64.rpm
sudo rm -rf kibana-7.5.1-x86_64.rpm

# Configure the kibana.yml

sudo rm -rf /etc/kibana/kibana.yml 
sudo cat > /etc/kibana/kibana.yml <<'EOF'
server.port: 5601
server.host: "kibana"
server.name: "kibana"
elasticsearch.hosts: [ "http://elasticmaster1:9200" ]
logging.dest: /var/log/kibana/kibana.log
logging.quiet: false
logging.verbose: true
EOF

# Make log directory

mkdir /var/log/kibana

# Fix permissions

chown -R kibana:kibana /var/log/kibana
chown -R kibana:kibana /usr/share/kibana/

# Enable Kibana at startup and start Kibana

sudo systemctl daemon-reload
sudo systemctl start kibana.service

exit