# Watches Index Templates

A **set of Elasticsearch index templates** designed to store and enable querying of Elasticsearch operational statistics.
The templates are specifically designed to work well in combination with [watches](https://github.com/ViaQ/watches-cli)
CLI tool (see below).

Provided index templates assume JSON data is formatted as
[nested data](https://www.elastic.co/guide/en/elasticsearch/reference/master/nested.html).
JSON data provided by Elasticsearch stats REST endpoints may need transformation to be nested.
If you use [watches](https://github.com/ViaQ/watches-cli) to poll data from Elasticsearch then you can use
`--transform` option to handle the data transformation accordingly.

There are provided useful [`scripts`](scripts) and [`fluentd`](fluentd) configuration demonstrating how to setup
and use index templates correctly.

# Tutorial

In this tutorial we will setup Elasticsearch cluster to poll operational stats from and store this data back to the
same cluster. More specifically, we will be polling ES REST APIs by watches to log files. These log files are then
tailed by fluentd and pushed back to the same Elasticsearch cluster. This creates infamous _feedback-loop_ and is not
recommended setup for production but is ok for the demo. For production it is recommended to point the fluentd to
different Elasticsearch cluster.

````
                    +-----------+
              +-----|  watches  |-----+
              |     +-----------+     |
              |                       |
    +-------------------+             V
    |                   |        +-------------+
    |   Elasticsearch   |      +-------------+ |
    |                   |      |  Log files  |-+
    | (index templates) |      +-------------+
    +-------------------+             |
              A                       |
              |     +-----------+     |      
              +-----|  fluentd  |-----+
                    +-----------+
````

## Requirements

- the latest **`watches`** cli tool (`1.0.2-dev` or higher), see watches docs for [installation instructions](https://github.com/ViaQ/watches-cli#install)
- installed **Elasticsearch 2.4.4**, either [download](https://www.elastic.co/downloads/past-releases/elasticsearch-2-4-4) it manually or install using [package](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/setup-repositories.html) manager 
- installed **`fluentd`** and **`fluent-plugin-elasticsearch`**, see [fluentd docs](http://docs.fluentd.org/v0.12/articles/recipe-json-to-elasticsearch) for more details
- (optional) configure `ES_BIN` env variable to point to `bin/elasticsearch` startup script 

## Setup

After Elasticsearch, fluentd and watches is installed you can follow instructions:

````bash
# ----------------------------------
# Clone git repo and navigate to 'scripts' folder
# ----------------------------------
git clone https://github.com/lukas-vlcek/watches_index_templates.git
cd watches_index_templates/scripts

# ----------------------------------
# Start and initialize Elasticsearch
# ----------------------------------
# Make sure ${ES_BIN} points to valid Elasticsearch startup script.
# There is no need to setup ${ES_BIN} if 'elasticsearch' CLI command works OOB.
${ES_BIN} --version
$ Version: 2.4.4, Build: fcbb46d/2017-01-03T11:33:16Z, JVM: 1.8.0_65

# Start local Elasticsearch node
./start_elasticsearch.sh

# Push index templates
./push_templates.sh

# ----------------------------------
# Start fluentd
# ----------------------------------
# This process will tail log files (these are populated by watches, see below)
# and push the data back to Elasticsearch cluster.
./start_fluentd.sh

# ----------------------------------
# Start watches processes
# ----------------------------------
# Watches will start polling ES stats and store the data to log files.
# By default watches processes will run 60 seconds and then terminate.
# You can change this duration by passing a number as the first parameter to this script.
#
# Example: ./start_watches.sh 10
# This will terminate all processes after 10 seconds.
# You can also terminate this script manually at any time.
./start_watches.sh
````

Scripts `start_elasticsearch.sh`, `push_templates.sh` and `start_fluentd.sh` share common configuration file
[`_configure_env.sh`](scripts/_configure_env.sh)
 which can be adjusted or included env variables can be setup to override the default values. These scripts also
 accept `-v` parameter to force debug output.

## Optional

To get more _realistic_ stats data from Elasticsearch you can consider running parallel intensive indexing task,
  for example you can use [stream2es](https://github.com/elastic/stream2es.git) tool to index Wikipedia dump.
  
See [optional indexer documentation](scripts/optional_indexer/README.md) for more details.

## Query stored data
 
Indexed data can be queried to get more insight into Elasticsearch cluster operational statistics.
Stay tuned for more information.

## License

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