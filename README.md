Index templates used to store Elasticsearch stats data.

Requires:

- the latest **watches** cli tool, see watches docs for [installation instructions](https://github.com/ViaQ/watches-cli#install)
- installed Elasticsearch 2.4.x
- configure `ES_BIN` env variable to point to `bin/elasticsearch` script 

How to use it:

````bash
cd scripts

# Start local Elasticsearch node
./start_elasticsearch.sh

# Push index templates
./push_mappings.sh

# Start watches processes to poll ES stats
# and store them to log files
./start_watches.sh

# Start fluentd process to tail these log files
# and push them back to Elasticsearch
# (a.k.a create "feedback-loop", but it is just demo so it is ok) 
./start_fluentd.sh
````