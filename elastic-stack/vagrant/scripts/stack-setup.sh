#!/bin/bash

# Copy files from vagrant project to vagrant user home directory

cp /vagrant/playbooks/* /home/vagrant/
cp -r /vagrant/playbooks/roles/* /etc/ansible/roles

# Change directory

cd /home/vagrant

# Run Elasticsearch playbook to stand up the new stack
ansible-playbook -i /home/vagrant/inventory --private-key /home/vagrant/.ssh/ansible.pem -u vagrant ansible-elasticsearch.yml

# Run Kibana install playbook
ansible-playbook -i /home/vagrant/inventory --private-key /home/vagrant/.ssh/ansible.pem -u vagrant ansible-kibana.yml

# Run Logstash install playbook
ansible-playbook -i /home/vagrant/inventory --private-key /home/vagrant/.ssh/ansible.pem -u vagrant ansible-logstash.yml