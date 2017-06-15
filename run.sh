#!/usr/bin/env bash

set -euxo pipefail

cd ./scripts/

source ./_configure_env.sh

#echo "Is ES available at ${ES_SCHEME}://${ES_HOST}:${ES_PORT} ?"
#curl -s -X GET ${ES_SCHEME}://${ES_HOST}:${ES_PORT}

./init_kibana_indices.sh
./push_templates.sh
./start_fluentd.sh
./start_watches.sh -1
