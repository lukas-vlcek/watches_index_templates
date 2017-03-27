#!/usr/bin/env bash

ES=http://localhost:9200

#curl -X DELETE $ES/*

curl -X POST $ES/_template/cluster_health-2-4 -d@cluster_health_2-4-X.template.json
curl -X POST $ES/_template/cluster_stats-2-4  -d@cluster_stats_2-4-X.template.json