#!/usr/bin/env bash

# This script is to pull all dashboards entities from .kibana index and printed
# to stdout. It pull all documents for all found types in this index in alphabetical
# order so that commit diffs are easy.
#
# Example use:
# $ ./backup_kibana_index.sh > ../kibana/dashboards/.kibana_bulk_data

source _configure_env.sh

#echo "Does .kibana index exist?"
response_code=404
response_code=$(curl -s -X HEAD -w '%{response_code}' ${ES_URL}/.kibana)
#echo Response code: ${response_code}

if [ ${response_code} -ne 200 ]; then
  echo Kibana index does not exists, exit...
  exit;
fi

#echo "Available types in .kibana index:"
types=(`curl -s -X GET ${ES_URL}/.kibana/_search?pretty -d '{
  "size": 0,
  "aggs": {
    "types": {
      "terms": {
        "field": "_type",
        "size": 100,
        "order": {
          "_term": "asc"
        }
      }
    }
  }
}' | jq -r .aggregations.types.buckets[].key`)

for type in "${types[@]}"
do
#  echo "Type:"
#  echo ${type}
  ids=(`curl -s -X GET ${ES_URL}/.kibana/${type}/_search?pretty -d '{
    "size": 2000,
    "sort": [
      { "_uid": { "order": "asc" }}
    ]
  }' | jq -r .hits.hits[]._id`)

#  echo "ids:"

  for id in ${ids[@]}
  do
#    echo ${id}
    path=$(urlencode ${type})/$(urlencode ${id})
    data=`curl -s -X GET "${ES_URL}/.kibana/${path}"`
    echo ${data} | jq -c '{index: {_index: ._index, _type: ._type, _id: ._id}}'
    echo ${data} | jq -c ._source
  done
done

echo ""
