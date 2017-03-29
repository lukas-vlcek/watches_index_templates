#!/usr/bin/env bash

# Not needed, notice that we already accept TTL script parameter so using config script would clash with that.
#source _configure_env.sh

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
  nohup ./$1 $TTL 2> /dev/null &
  sleep 0.2
  childs=`pgrep -P $!`
  ppids="$ppids $!"
  allpids="$allpids $! $childs"
}

start_script collect-cluster-health.sh
start_script collect-cluster-stats.sh
start_script collect-nodes-stats.sh

echo jobs started, pids:
echo $allpids

wait $ppids

echo done...