#!/usr/bin/env bash

ls -la .
ls -la ./kibana/
ls -la ./fluentd/
ls -la ./scripts/

cd ./scripts/

./start_fluentd.sh
./start_watches.sh
