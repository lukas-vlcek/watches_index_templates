#!/usr/bin/env bash

source _configure_env.sh

TTL=${1:-60}

watches nodes_stats \
  -d $TTL -i 3 \
  -sblt \
  --transform=nested \
  --url=${ES_URL} \
> ${PATH_WATCHES_CLUSTER_HEALTH_LOGS}