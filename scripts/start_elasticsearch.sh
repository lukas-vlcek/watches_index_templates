#!/usr/bin/env bash

source _configure_env.sh

function wait_for_es {

    RETRY_INTERVAL=1
    max_time=1
    retry=60

    while ! response_code=$(curl -X HEAD -s \
        --max-time ${max_time} \
        -w '%{response_code}' \
        ${ES_URL}) || test ${response_code} != "200"
    do
        echo -n "."
        sleep ${RETRY_INTERVAL}
        (( retry -= 1 ))
        if (( retry == 0 )) ; then
            exit 1;
        fi
    done
}

function wait_for_status {

    status=yellow
    timeout=10

    response_code=$(curl -X GET -s \
        -w '%{response_code}' \
        "${ES_URL}/_cluster/health?wait_for_status=${status}&timeout=${timeout}s")

    if [[ "${response_code}" != *200 ]]; then
        echo "Cluster did not reach expected ${status} cluster health status within ${timeout}s"
        exit 1;
    else
        echo "OK: Elasticsearch cluster is in ${status} status"
    fi
}

# Start ES in background
`${ES_BIN} -d`

EXIT_CODE=$?

if [ ${EXIT_CODE} == 0 ]; then
  echo "Elasticsearch was started"
  echo "Waiting for HTTP port open"
  wait_for_es;
  echo ""
  echo "Waiting for expected cluster status"
  wait_for_status;
else
  echo "Something went wrong while starting Elasticsearch"
  exit 1;
fi