# Quotes Spider 

Web Scraping [Quotes to Scrape](http://quotes.toscrape.com/)'s quote list with [Scrapy](https://scrapy.org/) and indexing them with Azure Search

## Pre-requisites
* Python3
* Scrapy: You can install Scrapy and its dependencies from PyPI with "pip install Scrapy". For Scrapy installation, please see [this](https://doc.scrapy.org/en/latest/intro/install.html)
* CosmosDB Account: You can create a DocumentDB database account using [the Azure portal](https://azure.microsoft.com/en-us/documentation/articles/documentdb-create-account/), or [Azure Resource Manager templates and Azure CLI](https://azure.microsoft.com/en-us/documentation/articles/documentdb-automation-resource-manager-cli/)
* AzureSearch Account: You can spin up an Azure Search service in the [Azure portal](https://docs.microsoft.com/en-us/azure/search/search-create-service-portal) or through the [Azure Resource Management API](https://docs.microsoft.com/en-us/rest/api/searchmanagement/). 

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

### AzureSearch Index Schema and Indexer

First, change directory to azsearch and edit azure.conf
```
AZURE_SEARCH_SERVICE_NAME='<Azure Search Service name>'
AZURE_SEARCH_API_VER='2016-09-01'
AZURE_SEARCH_ADMIN_KEY='<Azure Search API Admin Key>'
AZURE_SEARCH_INDEX_NAME='<Azure Search Index Name>'
AZURE_SEARCH_INDEXER_NAME='<Azure Search Indexer Name>'
AZURE_SEARCH_INDEXER_DATASOURCE_NAME='<Azure Search Indexer DataSource Name>'
DOCDB_HOST='https://<DocumentDB_Account_Name>.documents.azure.com:443/'
DOCDB_DB='<DocumentDB Database Name>'
DOCDB_COLLECTION='<DocumentDB Collection Name>'
DOCDB_MASTER_KEY='<DocumentDB Master Key>'

( example azure.conf )
AZURE_SEARCH_SERVICE_NAME='yoichikademo'
AZURE_SEARCH_API_VER='2016-09-01'
AZURE_SEARCH_ADMIN_KEY='BF205B6F596B2058E67A978E92D96E12'
AZURE_SEARCH_INDEX_NAME='quotes'
AZURE_SEARCH_INDEXER_NAME='docdbindexer'
AZURE_SEARCH_INDEXER_DATASOURCE_NAME='docdbds-quotes'
DOCDB_HOST='https://yoichikademo.documents.azure.com:443/'
DOCDB_DB='feeddb'
DOCDB_COLLECTION='quotescoll'
DOCDB_MASTER_KEY='EMwUa3EzsstJ1qYfzwo9nQ3KudofsXNm3xLh1SLffKkUHMFl80OZRZIVu4lxdKRKxkgVAj0c2mv9BZSyMN7tdg=='
```

Then, execute 3 scripts in the following order
```
# (1) Create Azure Search Index
./create-index.sh

# (2) Create Data source for Azure Search Indexer
./create-datasource.sh

# (3) Create Azure Search Indexer
./create-indexer.sh
```

Or you can simply run setup.sh which internally execute the scripts above 
```
./setup.sh
```

## Run spider and Test

First, change directory to quotes_spider, then start running and qutote spider like this. The spider will collect all quotes in the site store them into DocumentDB. On the indexer side, Azure Search indexer that you created regularly crawls documents in DocumentDB and index them.
```
cd quotes_spider
scrapy crawl quotes
# Or if you want to export output into csv file, do like this
scrapy crawl quotes -o result.csv
```

Finally run search test command like this, then you'll see results returned if everything goes ok
```
./search-index.sh

Start Searching Index: quotes ....
{
    "@odata.context": "https://yoichikademo2.search.windows.net/indexes('quotes')/$metadata#docs",
    "@odata.count": 100,
    "value": [
        {
            "@search.score": 1,
            "id": "502c134f33748b1252c8d90c0f3c1be053bb970a64d9dafe113d07b15fdeaba8",
            "author": "Steve Martin",
            "text": "“A day without sunshine is like, you know, night.”"
        }
    ]
}
```
