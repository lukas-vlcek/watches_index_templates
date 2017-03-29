# Watches Index Templates

A **set of Elasticsearch index templates** designed to store and enable querying of Elasticsearch operational statistics.
The templates are specifically designed to work well in combination with [watches](github.com/ViaQ/watches-cli) CLI
tool.

Index templates assume JSON data is formatted as
[nested data](https://www.elastic.co/guide/en/elasticsearch/reference/master/nested.html)
(JSON data provided by Elasticsearch stats REST endpoints may need transformation to be nested).
If you use [watches](github.com/ViaQ/watches-cli) to poll data from Elasticsearch then you can use `--transform` option
to handle the data transformation accordingly.

The following are provided [`scripts`](scripts) and [`fluentd`](fluentd) configuration demonstrating how to setup
and use index templates correctly.

# How To

In the following demo we will use local Elasticsearch to poll operational stats from and store this data back to the
same instance. More specifically, we will be polling ES REST APIs by watches to log files. These log files are then
tailed by fluentd and pushed back to the same Elasticsearch cluster. This creates infamous "feedback-loop" and is not
recommended setup for production setup but is ok for demo. For production it is recommended to point the fluentd to
different Elasticsearch cluster.

````
                    +-----------+
              +-----|  watches  |-----+
              |     +-----------+     |
              |                       |
    +-------------------+             |
    |                   |             V
    |   Elasticsearch   |      +-------------+
    |                   |      |  Log files  |
    | (index templates) |      +-------------+
    +-------------------+             |
              A                       |
              |     +-----------+     |      
              +-----|  fluentd  |-----+
                    +-----------+
````

## Requirements

- the latest **watches** cli tool, see watches docs for [installation instructions](https://github.com/ViaQ/watches-cli#install)
- installed **Elasticsearch 2.4.x**
- \[optional\] configure `ES_BIN` env variable to point to starting `bin/elasticsearch` script 

## Setup

After Elasticseach and watches is installed 

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

## License

[ASL v2](https://www.apache.org/licenses/LICENSE-2.0)

````
Copyright 2017 Lukáš Vlček

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
````