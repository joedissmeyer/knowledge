# Vagrant for demo Elastic Stack

This is a self-contained vagrant demo lab.

Tested on Windows 10 20H2 and macOS 11.3 Big Sur

## Requirements

- Minimum 16gb of system RAM is required to run this vagrantfile
- Each vagrant box needs internet access
- Vagrant 2.2.x or newer
- VirtualBox 6.1.x or newer
- TCP port 9200 cannot be in use on your localhost. This port will be used by Elasticsearch.
- TCP port 5601 cannot be in use on your localhost. This port will be used by Kibana.

## How-to

1. Clone down this repo.
2. Navigate to the vagrantfile location then run `vagrant up`.

Cluster will take several minutes (between 10 to 20 depending on your specs) to fully spin up.
Then, AFTER the vagrant up completes, Kibana still takes an additional minute or two to finally run. If you attempt to access the Kibana UI immediately you will be presented with "Kibana server is not ready". But just retry again in a minute and the UI will finally appear. 

If any errors occur during the vagrant up, cancel out of the command and run `vagrant destroy -f` to destroy the entire environment. Start over from scratch.
Confirm you have internet access to github.com and elastic.co then run `vagrant up` again.
Vagrant up _must complete without any errors_ in order for the demo lab cluster to run as expected.

To access, browse to http://localhost:5601. Log in.

Kibana username: elastic
Password: elastic

## SSH Access and User accounts

This lab uses the default "vagrant" user. 
Username: vagrant
Password: vagrant

The Vagrant user is _also_ the ansible control node user and has been configured as such.

To SSH to a running vagrant box, navigate to the Vagrantfile directory in your shell and execute `vagrant ssh <box_name>`.
For example, `vagrant ssh es01`.

## TLS Certs

## Cluster Details

Cluster name: `vagrant-cluster`

Only creates a fully functional 3 node Elasticsearch cluster with Kibana on its own dedicated host and one dedicated Logstash host, all ready to ingest data. This is suitable for a quick demo lab build of the Elastic Stack.

This vagrant spins up the following hosts:

- 10.0.0.1 - Hostname 'es01'     - Elasticsearch. Runs all roles (master, data, ingest, ml)
- 10.0.0.2 - Hostname 'es02'     - Elasticsearch. Runs all roles (master, data, ingest, ml)
- 10.0.0.3 - Hostname 'es03'     - Elasticsearch. Runs all roles (master, data, ingest, ml)
- 10.0.0.4 - Hostname 'logstash' - Logstash instance using Geerlingguy's ansible role.
- 10.0.0.5 - Hostname 'kibana'   - Elasticsearch Client role, full Kibana UI

Other notes:
- X-Pack 30 day license trial is enabled 
- Metricbeat metric collection installed on each host.
- Only the Kibana host has ports that will be exposed from the Vagrant environment to your localhost so you can query the Elasticsearch API and access the Kibana HTTP site for the cluster.
- All hosts run CentOS 7 with 2gb of RAM. Hence the 16GB system RAM requirement.

## To-do

- Automate on-the-fly creation of TLS certs instead of using the `scripts/es-create-tls-cert-files.sh` to manually embed certs files. These certs were created using openssl on my WSL Ubuntu instance so they are "bogus" anyways. Also they are only good for 365 days from 2021-05-28. So automating the cert creation is a must.
- Add Beats
- Add APM Server
- Add SIEM