#!/usr/bin/env bash

source _configure_env.sh

TTL=${1:-60}

echo "Polling nodes_stats to ${PATH_WATCHES_NODES_STATS_LOGS}"

watches nodes_stats \
  -d $TTL -i 3 \
  -sblt \
  --transform=nested \
  --url=${ES_SOURCE_URL} \
> ${PATH_WATCHES_NODES_STATS_LOGS}