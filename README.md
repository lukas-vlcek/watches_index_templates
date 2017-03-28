Index templates used to store Elasticsearch stats data.

Notice, index templates assume incoming JSON data is formatted as a nested data. If you use watches to poll data
from Elasticsearch then you can use `--transform` option to handle the data transformation accordingly.
If you use provided [`scripts`](scripts) then they are all setup to handle
this for you. 

## Requires

- the latest **watches** cli tool, see watches docs for [installation instructions](https://github.com/ViaQ/watches-cli#install)
- installed **Elasticsearch 2.4.x**
- configure `ES_BIN` env variable to point to `bin/elasticsearch` script 

## How to

In this demo we will use local Elasticsearch node to poll stats from and store this data back to it again.
This creates "feedback-loop" which is not recommended for production use but is ok for demo. 

````bash
git clone https://github.com/lukas-vlcek/watches_mapping.git
cd watches_mapping
cd scripts

# Start local Elasticsearch node
./start_elasticsearch.sh

# Push index templates
./push_mappings.sh

# Start fluentd process to tail log files (populated by watches, see below)
# and push the data back to the same Elasticsearch.
./start_fluentd.sh

# Start watches processes to poll ES stats
# and store them to log files.
# By default watches processes will run 60 seconds and then terminate.
# You can change this duration by passing a number as a first parameter to this script.
# Example: ./start_watches.sh 10
# You can also terminate this script manually at any time.
./start_watches.sh
````

## Optional

To get more _realistic_ stats data from Elasticsearch you can consider running parallel intensive indexing task,
  for example you can use [stream2es](https://github.com/elastic/stream2es.git) tool to index Wikipedia dump.
  
See [optional indexer documentation](scripts/optional_indexer/README.md) for more details.