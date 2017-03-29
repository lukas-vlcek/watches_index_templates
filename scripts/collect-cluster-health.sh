#!/usr/bin/env bash

source _configure_env.sh

TTL=${1:-60}

echo "Polling cluster_health to ${PATH_WATCHES_CLUSTER_HEALTH_LOGS}"

watches cluster_health \
  -d $TTL -i 3 \
  -sblt \
  --transform=nested \
  --url=${ES_URL} \
> ${PATH_WATCHES_CLUSTER_HEALTH_LOGS}