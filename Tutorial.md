# Watches index templates tutorial

This tutorial will show how to get Elasticsearch monitoring up and running. We will go through the following steps in more details:

- collect Elasticsearch operational statistics using watches
- index statistics data to Elasticsearch using fluentd
- use Kibana to visualize collected data

## Install fluentd

See [official Fluentd documentation](http://docs.fluentd.org/v0.12/categories/installation) to see how.

Once installed, you can verify like this:

````bash
$ fluentd --version
fluentd 0.14.12
````

You can use the latest stable version, which is `0.12.x`.

## Install watches

Install the latest [watches](https://github.com/ViaQ/watches-cli) from PyPI or from upstream GitHub repo. See how:

- Install watches using **PyPI**:

````bash
$ pip install watches
...
$ watches --version
1.0.2
````
-  or get watches from **GitHub** repo and install it manually:

````bash
$ git clone https://github.com/ViaQ/watches-cli.git
$ cd watches-cli
$ pip install -e .[test]
...
$ watches --version
1.0.3-dev
````

## Install Elasticsearch 2.4.4

Download from:
<https://www.elastic.co/downloads/past-releases/elasticsearch-2-4-4>

Start Elasticsearch.

## Install Kibana 4.6.4

Download from:
<https://www.elastic.co/downloads/past-releases/kibana-4-6-4>

**Do not start Kibana yet.** We will be importing `.kibana` index from provided snapshot
and it is important that the `.kibana` index is not created yet before we import it.

## Apply watches index templates

````bash
$ git clone https://github.com/lukas-vlcek/watches_index_templates.git
$ cd watches_index_templates/scripts
````

Make sure this tutorial will work with relevant code

````bash
$ git checkout tutorial-01
````

Push index templates into Elasticsearch:

````bash
$ ./push_templates.sh
````

## Collect Elasticsearch statistics

Make sure you are still in `watches_index_templates/scripts` folder (see above if not).

Start fluentd:

````bash
$ ./start_fluentd.sh
````
Fluentd is started and its PID is stored into `fluentd.pid` file.

Start watches. **This process will terminate after 60 seconds** if not told otherwise:

````bash
$ ./start_watches.sh
````
Watches will start collecting Elaticsearch statistics and the data will be stored into files under `logs` folder. From there the data is picked by fluentd and pushed back to Elasticsearch.

## Setup Kibana dashboards

Now, we have some statistics collected and stored in Elasticsearch. We are (almost) ready to visualize it using Kibana.

I haven't found a good any official support for exporting/importing kibana dashboards including index templates and scripted fields so we will workaround this
 by importing pre-canned `.kibana` index from provided index snapshot.
 (TODO: check how [Beats dashboards are imported](https://github.com/elastic/beats/tree/master/libbeat/dashboards))

Assuming Kibana hasn't been started yet and the `.kibana` index does not exists in ES you
can use the following script to import this index from provided snapshot.

````bash
$ ./import_kibana_index.sh
````

## Start Kibana

Start Kibana, navigate to its web UI (by default at <http://localhost:5601>) and open one
of provided dashboards:

- `cluster_level_monitoring` (recommended)
- `indices_level_monitoring`
- `nodes_level_monitoring`

Because we indexed just few data samples you will probably need to update the time selection filter (try "Relative: from 15 minutes ago to Now") 

All monitoring dashboards provide section (in top header part) to help navigate to other dashboards.
