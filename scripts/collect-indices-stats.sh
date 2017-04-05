#!/usr/bin/env bash

source _configure_env.sh

TTL=${1:-60}

echo "Polling indices_stats to ${PATH_WATCHES_INDICES_STATS_LOGS}"

watches indices_stats \
  -d $TTL -i 3 \
  -sblt \
  --level=shards \
  --transform=nested \
  --url=${ES_SOURCE_URL} \
> ${PATH_WATCHES_INDICES_STATS_LOGS}