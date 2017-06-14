#!/usr/bin/env bash

source _configure_env.sh

TTL=${1:-60}

echo "Polling just_nodes_stats to ${PATH_WATCHES_JUST_NODES_STATS_LOGS}"

watches just_nodes_stats \
  -d $TTL -i 3 \
  -sblt \
  --url=${ES_SOURCE_URL} \
  ${CERT_OPTIONS} \
> ${PATH_WATCHES_JUST_NODES_STATS_LOGS}
