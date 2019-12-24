# Elastic APM Server Configuration Examples

These are config examples for running an Elastic APM server.

## Information

Elastic APM is the new OSS server for the Elastic Stack. It is built on top of the beats codebase and follows the same diretory and .yml configuration layout.

Two examples in this directory are provided. One compatible with ELK v6.x and the other that is compatible for ELK v7.x.

## Directory Layout

`/usr/share/apm-server` -- Binaries and install location.
`/etc/apm-server/` -- Configuration file location.

## How to Install APM server v6.x (requires wget)

```shell
wget https://artifacts.elastic.co/downloads/apm-server/apm-server-6.8.5-x86_64.rpm
rpm -i apm-server-6.8.5-x86_64.rpm
rm -rf apm-server-6.8.5-x86_64.rpm
```

## How to Install APM server v7.x (requires wget)

```shell
wget https://artifacts.elastic.co/downloads/apm-server/apm-server-7.5.0-x86_64.rpm
rpm -i apm-server-7.5.0-x86_64.rpm
rm -rf apm-server-7.5.0-x86_64.rpm
```

## Configure the APM Server configuration file

```shell
vi /etc/apm-server/apm-server.yml
```

### Start APM-Server

```shell
service apm-server start
```

### Check log file for errors

```shell
tail -100f /var/log/apm/apm.log
```

## References

[Official Elastic APM Server Documentation](https://www.elastic.co/guide/en/apm/get-started/current/index.html)
