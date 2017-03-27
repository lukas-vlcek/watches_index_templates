#!/usr/bin/env bash

ES=http://localhost:9200

#curl -X DELETE $ES/*

curl -X POST $ES/_template/watches_defaults_2-4        -d@watches_defaults_2-4-X.template.json
curl -X POST $ES/_template/watches_cluster_health_2-4  -d@watches_cluster_health_2-4-X.template.json
curl -X POST $ES/_template/watches_cluster_stats_2-4   -d@watches_cluster_stats_2-4-X.template.json