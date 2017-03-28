Switch to the `scripts/optional_indexer` folder and download two additional components
into this folder: 

- Download the [wiki dump archive file](https://dumps.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles.xml.bz2) (this can take longer...):

````
curl https://dumps.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles.xml.bz2
````    
- Download the latest release of [stream2es](https://github.com/elastic/stream2es#install) tool and make it executable:

````
curl -O download.elasticsearch.org/stream2es/stream2es; chmod +x stream2es
````

Once done, go back up to [`scripts`](scripts) folder and run `index_wiki.sh`
script to start indexing wiki data to specified index.

For example to start indexing wiki data to index called `english_wiki`:
 
````
./index_wiki.sh english_wiki

# To auto terminate the process after 60 seconds you can do
./index_wiki.sh english_wiki 60 
````