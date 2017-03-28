Index templates used to store Elasticsearch stats data.

Notice, the index templates assume the incoming JSON data is formatted as a nested data. If you use watches to poll data
from Elasticsearch then you can use `--transform` option (see [#watches-cli/pull/29](https://github.com/ViaQ/watches-cli/pull/29)).
If you use provided [`scripts`](lukas-vlcek/watches_mapping/tree/master/scripts) then they will handle this for you, see below. 

Requires:

- the latest **watches** cli tool, see watches docs for [installation instructions](https://github.com/ViaQ/watches-cli#install)
- installed Elasticsearch 2.4.x
- configure `ES_BIN` env variable to point to `bin/elasticsearch` script 

How to use it:

In this demo we will use local Elasticsearch node to poll stats from and store this data back to it again.
This creates "feedback-loop" which is not recommended for production use, but is ok for demo. 

````bash
cd scripts

# Start local Elasticsearch node
./start_elasticsearch.sh

# Push index templates
./push_mappings.sh

# Start watches processes to poll ES stats
# and store them to log files.
# By default watches processes will run 60 seconds and then terminate.
# You can change this duration by passing a number as a first parameter to this script.
# Example: ./start_watches.sh 10
./start_watches.sh

# Start fluentd process to tail these log files
# and push them back to the same Elasticsearch.
./start_fluentd.sh
````