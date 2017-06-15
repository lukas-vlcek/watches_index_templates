#!/usr/bin/env bash

source _configure_env.sh

wait_for_port_open

# Get all .kibana* indices
indices=$(curl -s -X GET ${CURL_CERT_OPTIONS} ${ES_URL}/_cat/indices/.kibana*?h=index)

echo ${indices}
for index in "${indices[@]}"
do
  echo ${index}
done
