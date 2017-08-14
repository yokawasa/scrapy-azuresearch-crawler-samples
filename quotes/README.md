# Quotes Spider 


## Crawling Target Site
http://quotes.toscrape.com

## Pre-requisites
* Python3
* Scrapy
* CosmosDB Account
* AzureSearch Account

## Configurations
### Scrapy settings.py
```
# local logging
LOG_FILE = '/tmp/scrapy-quotespider.log'

# CosmosDB (DocumentDB) Configuration
DOCDB_HOST = 'https://yoichikademo1.documents.azure.com:443/'
DOCDB_DB = 'feeddb'
DOCDB_COLLECTION = 'feedcoll'
DOCDB_MASTER_KEY = 'xaxYsAtJ1qYfzwo9nQ3KudofsXNm3xLh1SLffKkUHMFl80OZRZIVu4lxdKRKxkgVAj0c2mv9BZSyMN7tdg=='
```

### AzureSearch Indexer

## Run and Test



