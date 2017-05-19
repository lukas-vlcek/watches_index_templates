#!/usr/bin/env bash

source _configure_env.sh

echo "Existing ES snapshots"
curl -X GET ${ES_URL}/_snapshot/?pretty

path=`cd ../kibana/backup; pwd`
echo "Create snapshot for location: ${path}"

curl -X PUT ${ES_URL}/_snapshot/kibana_dashboards?pretty -d"
{
    \"type\": \"fs\",
    \"settings\": {
        \"location\": \"${path}\",
        \"compress\": true
    }
}"

echo "Read snapshot info"
curl -X GET ${ES_URL}/_snapshot/kibana_dashboards/backup?pretty

echo "Restore the snapshot"
curl -X POST ${ES_URL}/_snapshot/kibana_dashboards/backup/_restore?pretty

echo ""
