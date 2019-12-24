# How to set up a new 3 node Consul v1.2.2 Cluster

## Article Description

This article describes the process for installing and bootstrapping a brand new production-ready 3 node Consul cluster.

## Audience

Consul admins

## Environment

RHEL/CentOS 7.x

## Information

This article assumes you are installing a new Consul 1.2.2 cluster on three RHEL/CentOS 7 servers. All commands below also assume you have full admin access to the servers.

## Process Flow

On your target servers create the consul user.
  
```[bash]
useradd -r consul
```

Make required directories and download Consul binary into the /usr/local/bin directory.

```[bash]
mkdir -p /etc/consul.d/{bootstrap,server,client}
mkdir /var/consul
chown -R consul:consul /var/consul
cd /usr/local/bin
wget https://releases.hashicorp.com/consul/1.2.2/consul_1.2.2_linux_amd64.zip
unzip consul_1.2.2_linux_amd64.zip
rm -rf consul_1.2.2_linux_amd64.zip
```

Create an encryption key for consul to use in the config file. Copy this key and save it. It will be used on all of the consul servers in their config file.

```[bash]
consul keygen
```

Next edit the bootstrap file on the **PRIMARY** server.

```[bash]
vi /etc/consul.d/bootstrap/config.json
```

Insert the following data into the `/etc/consul.d/bootstrap/config.json` file.

```[bash]
{
    "server": true,
    "datacenter": "main",
    "data_dir": "/var/consul",
    "encrypt": "<my-super-key>",
    "bootstrap_expect": 1,
    "ui": true,
    "log_level": "INFO",
    "start_join": [
        "consul-server-2",
        "consul-server-3"
    ],
    "client_addr": "0.0.0.0"
}
```

On the **primary** server, create the `/etc/consul.d/server/config.json` file. Insert the following text in the file:

```[bash]
{
    "server": true,
    "datacenter": "main",
    "data_dir": "/var/consul",
    "encrypt": "<my-super-key>",
    "ui": true,
    "log_level": "INFO",
    "start_join": [
        "consul-server-2",
        "consul-server-3"
    ],
    "client_addr": "0.0.0.0"
}
```

On **server #2**, create the `/etc/consul.d/server/config.json` file. Insert the following text in the file:

```[bash]
{
    "server": true,
    "datacenter": "main",
    "data_dir": "/var/consul",
    "encrypt": "<my-super-key>",
    "ui": true,
    "log_level": "INFO",
    "start_join": [
        "consul-server-1",
        "consul-server-3"
    ],
    "client_addr": "0.0.0.0"
}
```

And finally on **server #3**, create the `/etc/consul.d/server/config.json` file. Insert the following text in the file:

```[bash]
{
    "server": true,
    "datacenter": "main",
    "data_dir": "/var/consul",
    "encrypt": "<my-super-key>",
    "ui": true,
    "log_level": "INFO",
    "start_join": [
        "consul-server-1",
        "consul-server-2"
    ],
    "client_addr": "0.0.0.0"
}
```

On all three Consul servers, create the systemd startup file `/etc/systemd/system/consul.service`. Note that under the [service] block we are defining the `/etc/consul.d/server` configuration. We only use the bootstrap config file for setting up a new cluster.

```[bash]
[Unit]
Description=Consul Startup process
After=network.target

[Service]
Type=simple
ExecStart=/bin/bash -c '/usr/local/bin/consul agent -config-dir /etc/consul.d/server'
TimeoutStartSec=0

[Install]
WantedBy=default.target
```

On all three servers, reload the systemd daemon.

```[bash]
systemctl daemon-reload
```

On the **PRIMARY** server start up consul manually. This will choose the boostrap consul.json file since this is the first time startup for a new cluster. Wait for Consul to start.

```[bash]
consul agent -config-file=/etc/consul.d/bootstrap/config.json
```

After starting up the Consul server on the *PRIMARY* server, stop here. If there are any issues with startup get them resolved first before moving on. The primary Consul server *must* be running successfully before attempting to start the other two server cluster members.

Now that server #1 is up and running, manually start consul on the **SECOND & THIRD** nodes and verify they join the cluster just fine. Note we are using the `/etc/consul.d/server/config.json` file for the other two nodes.

```[bash]
consul agent -config-file=/etc/consul.d/server/config.json
```

After all three nodes join the cluster, stop Consul on the **PRIMARY** node.

```[bash]
ctrl+c
```

On the **PRIMARY** node start the consul service and verify it's running status. It must be running.

```[bash]
service consul startservice consul status
```

On the **SECOND & THIRD** nodes, one at a time, stop consul `(ctrl-c)` and start the consul service.

```[bash]
service consul start
service consul status
```

The Consul UI should be up and running on all three of the consul servers. Verify you can access them (no login required).

* <http://consul-server-1:8500/ui>
* <http://consul-server-2:8500/ui>
* <http://consul-server-3:8500/ui>

Profit.

## Resources

[Setup Consul Cluster Guide](https://devopscube.com/setup-consul-cluster-guide/)
