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
sudo echo '10.0.0.1 es01 es01' >> /etc/hosts
sudo echo '10.0.0.2 es02 es02' >> /etc/hosts
sudo echo '10.0.0.3 es03 es03' >> /etc/hosts
sudo echo '10.0.0.4 logstash logstash' >> /etc/hosts
sudo echo '10.0.0.5 kibana kibana' >> /etc/hosts