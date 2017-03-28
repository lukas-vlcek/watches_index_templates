#!/usr/bin/env bash

source ../_configure_env.sh

index_name=${1:-wiki}
interval=${2:-60}
allpids=""

function kill_proc {
  echo "Killing processes: ${allpids}"
  kill ${allpids}
}

trap kill_proc SIGHUP SIGQUIT SIGINT SIGTERM

echo "Start indexing wiki_dump to index "'$index_name'", the job will be automatically terminated in ${interval} seconds."

# Settings options does not seem to work, so we create index in advance
# see https://github.com/elastic/stream2es/issues/69
curl -X PUT ${ES_URL}/${index_name}/ -d '{ "settings": { "index": { "number_of_shards": 5, "number_of_replicas": 1 }}}'

nohup ./stream2es wiki --clobber true \
  --source ./optional_indexer/enwiki-latest-pages-articles.xml.bz2 \
  --target ${ES_URL}/${index_name} > $1_log.out 2> /dev/null &

echo "started pid $!"
allpids="${allpids} $!"

sleep ${interval}

kill_proc

#echo Indexing finished, doing "Index Flush"...
#curl -X POST ${ES_URL}/$index_name/_flush

echo Doing "Index Force Merge" followed by "Index Flush" if needed...
curl -X POST ${ES_URL}/${index_name}/_forcemerge?flush=true

echo Done.