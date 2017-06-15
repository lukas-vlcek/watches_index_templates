#!/usr/bin/env bash

if [[ $1 == "-v" ]]; then
  set -x
fi

ES_HOST=${ES_HOST:-localhost}
ES_PORT=${ES_PORT:-9200}
ES_SCHEME=${ES_SCHEME:-http}
ES_URL=${ES_URL:-${ES_SCHEME}://${ES_HOST}:${ES_PORT}}
FLUENTD_CONFIG=${FLUENTD_CONFIG:fluentd}
WORK_DIR=${WORK_DIR:-.}
INDEX_TEMPLATES_DIR=${INDEX_TEMPLATES_DIR:-$WORK_DIR/..}
ES_SOURCE_URL=${ES_SOURCE_URL:-$ES_URL}
CERT_OPTIONS=${CERT_OPTIONS:-}
CURL_CERT_OPTIONS=${CURL_CERT_OPTIONS:-}

ES_LOG_FILE=${ES_LOG_FILE:-${WORK_DIR}/elasticsearch_connect_log.txt}
RETRY_COUNT=${RETRY_COUNT:-300}
RETRY_INTERVAL=${RETRY_INTERVAL:-1}

retry=${RETRY_COUNT}
max_time=$(( RETRY_COUNT * RETRY_INTERVAL ))
timeouted=false

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

# Wait for Elasticsearch port to be opened. Fail on timeout or if response from Elasticsearch is unexpected.
wait_for_port_open() {
    rm -f $ES_LOG_FILE
    # test for ES to be up first and that our SG index has been created
    echo "Checking if Elasticsearch is ready on $ES_URL"
    while ! response_code=$(curl -s -X HEAD \
        ${CURL_CERT_OPTIONS} \
        --max-time $max_time \
        -o $ES_LOG_FILE -w '%{response_code}' \
        $ES_URL) || test $response_code != "200"
    do
        echo "."
        sleep $RETRY_INTERVAL
        (( retry -= 1 )) || :
        if (( retry == 0 )) ; then
            timeouted=true
            break
        fi
    done

    if [ $timeouted = true ] ; then
        echo "Timed out waiting for Elasticsearch to be ready"
    else
        rm -f $ES_LOG_FILE
        echo Elasticsearch is ready and listening at $ES_URL
        return 0
    fi
    cat $ES_LOG_FILE
    rm -f $ES_LOG_FILE
    exit 1
}
