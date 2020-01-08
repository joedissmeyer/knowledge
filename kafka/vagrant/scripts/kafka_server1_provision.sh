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

# Install Kakfa 1.1.1 binaries. Assumes OpenJRE 8 is already installed.

useradd -r kafka
cd /opt/
wget https://archive.apache.org/dist/kafka/1.1.1/kafka_2.11-1.1.1.tgz
tar -xvzf kafka_2.11-1.1.1.tgz
rm -rf kafka_2.11-1.1.1.tgz
mv /opt/kafka_2.11-1.1.1/ /opt/kafka-1.1.1
ln -s /opt/kafka-1.1.1/ /opt/kafka
mkdir /var/zookeeper
mkdir /var/log/kafka
chown -R kafka:kafka /opt/kafka*
chown -R kafka:kafka /var/zookeeper
chown -R kafka:kafka /var/log/kafka

# Create Zookeeper properties file for server 1

mv /opt/kafka/config/zookeeper.properties /opt/kafka/config/zookeeper.properties.original
cat > /opt/kafka/config/zookeeper.properties <<'EOF'
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/var/zookeeper
server.1=192.168.56.101:2888:3888
server.2=192.168.56.102:2888:3888
server.3=192.168.56.103:2888:3888
maxClientCnxns=0
EOF

# Create Kafka properties file for server 1

mv /opt/kafka/config/server.properties /opt/kafka/config/server.properties.original
cat > /opt/kafka/config/server.properties <<'EOF'
broker.id=1
delete.topic.enable=true
num.network.threads=3
num.io.threads=8
socket.send.buffer.bytes=1024000
socket.receive.buffer.bytes=1024000
socket.request.max.bytes=104857600

log.dirs=/var/log/kafka
num.partitions=3
num.recovery.threads.per.data.dir=1

inter.broker.protocol.version=1.1
log.message.format.version=1.1

log.retention.hours=96
log.retention.bytes=1073741824
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000

zookeeper.connect=10.128.24.70:2181,10.128.24.71:2181,10.128.24.72:2181
zookeeper.connection.timeout.ms=6000
EOF

# Make systemd unit file for zookeeper service

cat > /etc/systemd/system/zookeeper.service <<'EOF'
[Unit]
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
User=kafka
Group=kafka
Environment=LOG_DIR=/opt/kafka/logs
ExecStart=/opt/kafka/bin/zookeeper-server-start.sh /opt/kafka/config/zookeeper.properties
ExecStop=/opt/kafka/bin/zookeeper-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOF

# Make the myid file for Zookeeper

cat > /var/zookeeper/myid <<'EOF'
1
EOF

# Fix permissions

chown -R kafka:kafka /var/zookeeper

# Make systemd unit file for kafka service

cat > /etc/systemd/system/kafka.service <<'EOF'
[Unit]
Description=Apache Kafka
Requires=zookeeper.service
After=zookeeper.service

[Service]
Type=simple
User=kafka
Group=kafka
Environment=LOG_DIR=/opt/kafka/logs
ExecStart=/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
ExecStop=/opt/kafka/bin/kafka-server-stop.sh

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload