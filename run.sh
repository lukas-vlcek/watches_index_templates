#!/usr/bin/env bash

cd ./scripts/

echo "Is ES available at ${ES_SCHEME}://${ES_HOST}:${ES_PORT} ?"
curl -s -X GET ${ES_SCHEME}://${ES_HOST}:${ES_PORT}

./start_fluentd.sh
./start_watches.sh -1
