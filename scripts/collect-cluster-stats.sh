#!/usr/bin/env bash

source _configure_env.sh

TTL=${1:-60}

watches cluster_stats \
  -d $TTL -i 3 \
  -sbl \
  --transform=nested \
  --url=${ES_URL} \
> ${PATH_WATCHES_CLUSTER_STATS_LOGS}