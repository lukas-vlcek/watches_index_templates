#!/usr/bin/env bash

source _configure_env.sh

wait_for_port_open

# Get all .kibana* indices
indices=$(curl -s -X GET ${CURL_CERT_OPTIONS} ${ES_URL}/_cat/indices/.kibana*?h=index)

metadata_path=../kibana/dashboards

echo ${indices}
for index in ${indices}
do
  echo Insert dashboards into ${index} index
  #data=`cat ${metadata_path}/.kibana_bulk_data_without_config`
  #echo ${data//\"_index\":\".kibana\"/\"_index\":\"${index}\"} > ${metadata_path}/.kibana_bulk_data_without_config_specific
  ls -la ${metadata_path}
  sed 's/\"_index\":\".kibana\"/\"_index\":\"${index}\"/g' ${metadata_path}/.kibana_bulk_data_without_config > /tmp/.kibana_bulk_data_without_config_specific
#  echo "****************"
#  cat "${metadata_path}/.kibana_bulk_data_without_config_specific"
  curl -v -s -X POST ${CURL_CERT_OPTIONS} ${ES_URL}/_bulk?pretty --data-binary "@/tmp/.kibana_bulk_data_without_config_specific"
  rm /tmp/.kibana_bulk_data_without_config_specific
done
