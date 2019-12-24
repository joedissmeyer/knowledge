# Curator Configuration

This repository contains the configuration and actions examples for the Elasticsearch Curator tool.

## Information

Elasticsearch Curator helps you curate, or manage, your Elasticsearch indices and snapshots by:

1. Obtaining the full list of indices (or snapshots) from the cluster, as the actionable list
2. Iterate through a list of user-defined filters to progressively remove indices (or snapshots) from this actionable list as needed.
3. Perform various actions on the items which remain in the actionable list.

All that curator does is execute cleanup jobs for ELK cluster(s). Nothing more.

## Installation and architecture guidance

It is a good idea to install Curator on an Elasticsearch monitoring cluster (USOR7PELKESX01.use.ucdp.net), or a master node, then run it via cron.

An example `crontab` is provided in this directory for guidance.

Curator is extremely lightweight and only runs on-demand (usually via script or cronjob) so installing it and running it on a master node is not a concern. Remember that Curator does NOT run as an active service.

The actions yml and config yml should be stored in the same directory together.

It is a good idea to save them in `/opt/elasticsearch-curator/configs` or `/etc/curator`.

## Configuration

There are three example files provided:

- curator-actions-examples.yml
- curator-config-examples.yml
- crontab

These examples should be more than enough to get you started with figuring out your own unique data management strategy in your cluster.

To run curator it needs a configuration file (which tells curator what cluster to connect to with auth) and an actions file (the jobs it will perform.)

### curator-actions-examples.yml

Each action in this file must have a unique incremental number starting with `1`.
For each new action you add, make sure you increment the action id number.
Curator will not execute if the actions.yml config file is bad.

There are 7 different action examples provided:

- Delete the system-level .watcher-history- index data older than 30 days.
- Delete the system-level .reporting index data older than 60 days.
- Delete indices with the pattern "my-index-" that are older than 3 months using the `months` strategy.
- Delete indices with the pattern "my-index-" that are older than 30 days using the `days` strategy.
- Delete metricbeat hourly indices older than 15 days (i.e. 360 hours) using the `hours` strategy.
- Perform a forceMerge on all *DAILY* indices to the `max_num_segments` of `1` per shard.
- Perform a forceMerge on all *MONTHLY* indices to `max_num_segments` of `1` per shard.

### curator-config-examples.yml

This is a sample config for curator for connecting to a cluster.

The most important setting will be `http_auth`, which will be the user id and password of the curator user in the cluster that has permissions to perform the actions in the actions.yml file. If Xpack security is not enabled in the cluster then this can be removed.
