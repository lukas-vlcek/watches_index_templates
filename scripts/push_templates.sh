#!/usr/bin/env bash

source _configure_env.sh

#curl -X DELETE $ES_URL/*

curl -X POST ${ES_URL}/_template/watches_defaults_2-4            -d@${INDEX_TEMPLATES_DIR}/watches_defaults_2-4-X.template.json
curl -X POST ${ES_URL}/_template/watches_cluster_health_2-4      -d@${INDEX_TEMPLATES_DIR}/watches_cluster_health_2-4-X.template.json
curl -X POST ${ES_URL}/_template/watches_cluster_stats_2-4       -d@${INDEX_TEMPLATES_DIR}/watches_cluster_stats_2-4-X.template.json
curl -X POST ${ES_URL}/_template/watches_nodes_stats_2-4         -d@${INDEX_TEMPLATES_DIR}/watches_nodes_stats_2-4-X.template.json
curl -X POST ${ES_URL}/_template/watches_indices_stats_2-4       -d@${INDEX_TEMPLATES_DIR}/watches_indices_stats_2-4-X.template.json
curl -X POST ${ES_URL}/_template/watches_just_nodes_stats_2-4    -d@${INDEX_TEMPLATES_DIR}/watches_just_nodes_stats_2-4-X.template.json
curl -X POST ${ES_URL}/_template/watches_just_indices_stats_2-4  -d@${INDEX_TEMPLATES_DIR}/watches_just_indices_stats_2-4-X.template.json

echo ""
