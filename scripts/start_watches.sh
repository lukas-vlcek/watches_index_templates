#!/usr/bin/env bash

source _configure_env.sh

ppids=""
allpids=""
TTL=${1:-60}

function kill_pids {
  echo "Killing processes: $allpids"
  kill $allpids
}

trap kill_pids SIGHUP SIGQUIT SIGINT SIGTERM

function start_script {
  echo starting $1
  nohup ./$1 $TTL > ${PATH_WATCHES_LOGS}/watches-$1.log 2> /dev/null &
  sleep 0.2
  childs=`pgrep -P $!`
  ppids="$ppids $!"
  allpids="$allpids $! $childs"
}

echo Using watches version: `watches --version`

start_script collect-cluster-health.sh
start_script collect-cluster-stats.sh
start_script collect-nodes-stats.sh
start_script collect-indices-stats.sh
start_script collect-just-nodes-stats.sh
start_script collect-just-indices-stats.sh

echo jobs started, pids:
echo $allpids

wait $ppids

echo done...
