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
sudo echo '192.168.56.115 logstash logstash' >> /etc/hosts

# Install OpenJRE 11 and wget

sudo yum -y install java-11-openjdk wget

# Download and install Elasticsearch, clean up downloaded file

wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.5.1-x86_64.rpm
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.5.1-x86_64.rpm.sha512
shasum -a 512 -c elasticsearch-7.5.1-x86_64.rpm.sha512 
sudo rpm --install elasticsearch-7.5.1-x86_64.rpm
sudo rm -rf elasticsearch-7.5.1-x86_64.rpm

# Configure Node #1 in the ES cluster.

sudo rm -rf /etc/elasticsearch/elasticsearch.yml
sudo cat > /etc/elasticsearch/elasticsearch.yml <<'EOF'
cluster.name: vagrant-dev
cluster.initial_master_nodes:
  - elasticmaster1
node.name: ${HOSTNAME}
bootstrap.memory_lock: true
node.master: true
node.data: true
node.ingest: true
node.ml: false
network.host: [ "_eth1_" ]
http.port: 9200
discovery.seed_hosts: [ "elasticmaster1", "elasticmaster2", "elasticmaster3" ]
node.max_local_storage_nodes: 2

path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch

xpack.monitoring.enabled: true
xpack.security.enabled: false

EOF

# Disable swap and resolve bootstrap checks
sudo swapoff -a
sudo sysctl -w vm.max_map_count=262144
sudo echo 'vm.max_map_count = 262144' >> /etc/sysctl.conf
sudo echo 'elasticsearch - nofile 65536' >> /etc/security/limits.conf
sudo echo 'elasticsearch - nproc 2048' >> /etc/security/limits.conf
sudo echo 'elasticsearch soft memlock unlimited' >> /etc/security/limits.conf
sudo echo 'elasticsearch hard memlock unlimited' >> /etc/security/limits.conf
sudo echo 'MAX_OPEN_FILES=65535' >> /etc/sysconfig/elasticsearch
sudo echo 'MAX_LOCKED_MEMORY=unlimited' >> /etc/sysconfig/elasticsearch
sudo echo 'MAX_MAP_COUNT=262144' >> /etc/sysconfig/elasticsearch
mkdir /etc/systemd/system/elasticsearch.service.d
sudo cat > /etc/systemd/system/elasticsearch.service.d/override.conf<<'EOF'
[Service]
LimitMEMLOCK=infinity
EOF

# Edit JVM config for Elasticsearch

sudo mv /etc/elasticsearch/jvm.options /etc/elasticsearch/jvm.options.original
sudo cat > /etc/elasticsearch/jvm.options <<'EOF'
-Xms1g
-Xmx1g

## GC configuration
-XX:+UseConcMarkSweepGC
-XX:CMSInitiatingOccupancyFraction=75
-XX:+UseCMSInitiatingOccupancyOnly

## JVM temporary directory
-Djava.io.tmpdir=${ES_TMPDIR}

## heap dumps
# generate a heap dump when an allocation from the Java heap fails
# heap dumps are created in the working directory of the JVM
-XX:+HeapDumpOnOutOfMemoryError

# specify an alternative path for heap dumps; ensure the directory exists and
# has sufficient space
-XX:HeapDumpPath=/var/lib/elasticsearch

# specify an alternative path for JVM fatal error logs
-XX:ErrorFile=/var/log/elasticsearch/hs_err_pid%p.log

## JDK 8 GC logging
8:-XX:+PrintGCDetails
8:-XX:+PrintGCDateStamps
8:-XX:+PrintTenuringDistribution
8:-XX:+PrintGCApplicationStoppedTime
8:-Xloggc:/var/log/elasticsearch/gc.log
8:-XX:+UseGCLogFileRotation
8:-XX:NumberOfGCLogFiles=32
8:-XX:GCLogFileSize=64m

# JDK 9+ GC logging
9-:-Xlog:gc*,gc+age=trace,safepoint:file=/var/log/elasticsearch/gc.log:utctime,pid,tags:filecount=32,filesize=64m

EOF

# Ensure the elasticsearch user has full ownership of the config directory

sudo chown -R elasticsearch:elasticsearch /etc/elasticsearch

# Reload system units

sudo systemctl daemon-reload

# Start Elasticsearch 

sudo systemctl start elasticsearch.service

exit