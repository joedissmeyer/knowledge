#!/bin/bash

echo "Enter Version number to Upgrade: "

read version

echo "------ Download Elastic APM Server -------"
wget https://artifacts.elastic.co/downloads/apm-server/apm-server-$version-x86_64.rpm

echo "------ Stopping Elastic APM Server -------"
service apm-server stop

echo "------ Install Elastic APM Server -------"
rpm --upgrade apm-server-$version-x86_64.rpm

echo "------ Configure the logging output configuration for APM Server----"
cat > /etc/systemd/system/apm-server.service.d/logging.conf <<'EOF'
[Service]
Environment="BEAT_LOG_OPTS="
EOF

echo "------ Reload the service daemon ------"
systemctl daemon-reload

echo "------ Starting Elastic APM Server -------"
service apm-server start

echo "------ Final Cleanup -------"
rm -rf ./apm-server-$version-x86_64.rpm

echo "------ SCRIPT DONE!!! -------"