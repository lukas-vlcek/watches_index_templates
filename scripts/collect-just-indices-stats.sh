#!/usr/bin/env bash

source _configure_env.sh

TTL=${1:-60}

echo "Polling just_indices_stats to ${PATH_WATCHES_JUST_INDICES_STATS_LOGS}"

watches just_indices_stats \
  -d $TTL -i 3 \
  -sblt \
  --level=indices \
  --url=${ES_SOURCE_URL} \
> ${PATH_WATCHES_JUST_INDICES_STATS_LOGS}
