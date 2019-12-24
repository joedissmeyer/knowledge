# Sample Watches

This package provides a collection of example watches.  These watches have been developed for the purposes of POC's and demonstrations.

## Generic Assumptions

* Elasticsearch 6.x with Xpack or newer
* All watches assume Watcher is running in the same cluster as that in which the relevant data is hosted.

## Watches

There are several watch examples listed below based off my own experience and needs.

For more examples, check the official Elastic [Sample Watch](https://github.com/elastic/examples/blob/master/Alerting/Sample%20Watches/README.md) repo.

### watch-chain-example-with-2-searches

Uses the `chain` input to execute multiple queries, each with aggregations per chain input, to use as a compare in the condition.

The condition uses a simple painless script to evaluate.

### watch-complex-schedule

An example watch for configuring a complex daily schedule.

> The time schedule in every watch executes on UTC time. You can use <www.worldtimebuddy.com> to translate UTC to local time.

### watch-correllate-aggs-with-multiple-chains

This is another watch that uses the `chain` input to execute multiple queries each with an aggregation per chain. However, the `first` chain aggregation is used as an input for the `second` chain.

This is one method of performing a correlation in a log index where something like an `correlation_id` exists in each log entry but the initial request is written to one log entry and an error is in a different log entry. The key to this example is that there needs to be *some type* of correlation in the different log entries to generate this watch alert.

### watch-simple-text-query

This is one of the most common watch types. It searches for a specific line of text in the index and triggers an alert when found.
