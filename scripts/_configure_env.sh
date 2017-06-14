#!/usr/bin/env bash

if [[ $1 == "-v" ]]; then
  set -x
fi

WORK_DIR=${WORK_DIR:-.}
INDEX_TEMPLATES_DIR=${INDEX_TEMPLATES_DIR:-$WORK_DIR/..}
ES_URL=${ES_URL:-http://localhost:9200}
ES_SOURCE_URL=${ES_SOURCE_URL:-$ES_URL}
CERT_OPTIONS=${CERT_OPTIONS:-}

ES_BIN=${ES_BIN:-elasticsearch}

PATH_WATCHES_LOGS=${PATH_WATCHES_LOGS:-$WORK_DIR/logs}
PATH_WATCHES_CLUSTER_HEALTH_LOGS=${PATH_WATCHES_CLUSTER_HEALTH_LOGS:-$PATH_WATCHES_LOGS/cluster_health.log}
PATH_WATCHES_CLUSTER_STATS_LOGS=${PATH_WATCHES_CLUSTER_STATS_LOGS:-$PATH_WATCHES_LOGS/cluster_stats.log}
PATH_WATCHES_NODES_STATS_LOGS=${PATH_WATCHES_NODES_STATS_LOGS:-$PATH_WATCHES_LOGS/nodes_stats.log}
PATH_WATCHES_INDICES_STATS_LOGS=${PATH_WATCHES_INDICES_STATS_LOGS:-$PATH_WATCHES_LOGS/indices_stats.log}
PATH_WATCHES_JUST_NODES_STATS_LOGS=${PATH_WATCHES_JUST_NODES_STATS_LOGS:-$PATH_WATCHES_LOGS/just_nodes_stats.log}
PATH_WATCHES_JUST_INDICES_STATS_LOGS=${PATH_WATCHES_JUST_INDICES_STATS_LOGS:-$PATH_WATCHES_LOGS/just_indices_stats.log}

export PATH_WATCHES_CLUSTER_HEALTH_LOGS
export PATH_WATCHES_CLUSTER_STATS_LOGS
export PATH_WATCHES_NODES_STATS_LOGS
export PATH_WATCHES_INDICES_STATS_LOGS
export PATH_WATCHES_JUST_NODES_STATS_LOGS
export PATH_WATCHES_JUST_INDICES_STATS_LOGS

# Based on https://unix.stackexchange.com/questions/159253/decoding-url-encoding-percent-encoding
urlencode() {
    out=""
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) out+=$( printf "$c") ;;
            *) out+=$(printf '%%%02X' "'$c")
        esac
    done
    echo $out
}


