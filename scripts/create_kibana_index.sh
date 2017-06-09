#!/usr/bin/env bash

source _configure_env.sh

echo "Does .kibana index exist?"
response_code=404
response_code=$(curl -s -X HEAD -w '%{response_code}' ${ES_URL}/.kibana)
echo Response code: ${response_code}

if [ ${response_code} -eq 200 ]; then
  echo Kibana index already exists, exit...
  exit;
fi

metadata_path=../kibana/dashboards

echo "Create Kibana index"

curl -X PUT ${ES_URL}/.kibana -d@${metadata_path}/.kibana_mapping.json

echo "Push dashboards data"
curl -s -X POST ${ES_URL}/_bulk?pretty --data-binary "@${metadata_path}/.kibana_bulk_data"

echo ""
