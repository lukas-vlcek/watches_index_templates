#!/usr/bin/env bash

source _configure_env.sh

TTL=${1:-60}

echo "Polling cluster_stats to ${PATH_WATCHES_CLUSTER_STATS_LOGS}"

watches cluster_stats \
  -d $TTL -i 3 \
  -sbl \
  --transform=nested \
  --url=${ES_URL} \
> ${PATH_WATCHES_CLUSTER_STATS_LOGS}