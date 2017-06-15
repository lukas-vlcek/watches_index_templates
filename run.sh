#!/usr/bin/env bash

cd ./scripts/

echo "Is ES available?"
curl -X GET ${ES_PROTOCOL}://${ES_HOST}:${ES_PORT}

./start_fluentd.sh
./start_watches.sh -1
