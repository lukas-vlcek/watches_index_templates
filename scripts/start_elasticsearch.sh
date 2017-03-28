#!/usr/bin/env bash

source ./configure_env.sh

# Start ES in background
`$ES_BIN -d`

EXIT_CODE=$?

if [ $EXIT_CODE == 0 ]; then
  echo ok
else
  echo "Something went wrong while starting Elasticsearch"
  exit 1;
fi