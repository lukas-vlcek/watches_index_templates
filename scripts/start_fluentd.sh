#!/usr/bin/env bash

source _configure_env.sh

function check_dir {
  if [ ! -d $1 ]; then
    echo "Creating folder $1"
    mkdir $1
  fi
}

check_dir ${PATH_WATCHES_LOGS}

FILES="${PATH_WATCHES_CLUSTER_HEALTH_LOGS}
${PATH_WATCHES_CLUSTER_STATS_LOGS}
${PATH_WATCHES_NODES_STATS_LOGS}
${PATH_WATCHES_INDICES_STATS_LOGS}
${PATH_WATCHES_JUST_NODES_STATS_LOGS}
${PATH_WATCHES_JUST_INDICES_STATS_LOGS}"

for f in ${FILES}
do
  touch ${f} & echo "Log file ${f} is ready"
done

fluentd -c ../fluentd/fluentd.conf 2>&1 > ./fluentd.log &
pid=$!
echo ${pid} > ./fluentd.pid

echo "Fluentd starting with PID: ${pid}, output forwarded to fluentd.log file"
