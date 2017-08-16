# Craigslist Spider 

Web Scraping [Craigslist](https://tokyo.craigslist.jp/)'s Jobs in Tokyo with [Scrapy](https://scrapy.org/) and indexing them with Azure Search

## Pre-requisites
* **Python3**
* **Scrapy**: You can install Scrapy and its dependencies from PyPI with "pip install Scrapy". For Scrapy installation, see also [this](https://doc.scrapy.org/en/latest/intro/install.html)
* **pydocumentdb**: You can install pydocumentdb and its dependencies from PyPI with "pip install pydocumentdb". For pydocumentdb installation, see also [this](https://github.com/Azure/azure-documentdb-python)
* **CosmosDB Account**: You can create a DocumentDB database account using [the Azure portal](https://azure.microsoft.com/en-us/documentation/articles/documentdb-create-account/), or [Azure Resource Manager templates and Azure CLI](https://azure.microsoft.com/en-us/documentation/articles/documentdb-automation-resource-manager-cli/)
* **AzureSearch Account**: You can spin up an Azure Search service in the [Azure portal](https://docs.microsoft.com/en-us/azure/search/search-create-service-portal) or through the [Azure Resource Management API](https://docs.microsoft.com/en-us/rest/api/searchmanagement/). 

As explain above, you can install Scrapy and pydocumentdb python pakcage with PyPI like this:
```
pip install Scrapy
pip install pydocumentdb
```

## Configurations
### Scrapy settings.py
```
# local logging
LOG_FILE = '/tmp/scrapy-craigslistspider.log'

# CosmosDB (DocumentDB) Configuration
DOCDB_HOST = 'https://<DocumentDB_Account_Name>.documents.azure.com:443/'
DOCDB_DB = '<DocumentDB Database Name>'
DOCDB_COLLECTION = '<DocumentDB Collection Name>'
DOCDB_MASTER_KEY = '<DocumentDB Master Key>'
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
AZURE_SEARCH_SERVICE_NAME='yoichikademo2'
AZURE_SEARCH_API_VER='2016-09-01'
AZURE_SEARCH_ADMIN_KEY='aBF205B6F596B205C8E7A978E92D96E12'
AZURE_SEARCH_INDEX_NAME='craigslist'
AZURE_SEARCH_INDEXER_NAME='craigslistindexer'
AZURE_SEARCH_INDEXER_DATASOURCE_NAME='docdbds-craigslist'
DOCDB_HOST='https://yoichikademo1.documents.azure.com:443/'
DOCDB_DB='feeddb'
DOCDB_COLLECTION='craigslistcoll'
DOCDB_MASTER_KEY='aEMwUa3EzsAtJ1qYfzwo9nQ3KudofsXNm3xLh1SLffKkUHMFl80OZRZIVu4lxdKRKxkgVAj0c2mv9BZSyMN7tdg=='
```

Then, execute 4 scripts in the following order
```
# (1) Create Azure Search Index
./create-index.sh

# (2) Create Data source for Azure Search Indexer
./create-datasource.sh

# (3) Create DocuemtnDB Database and Collection
./create-docdb-init-dbcol.sh

# (4) Create Azure Search Indexer
./create-indexer.sh
```

Or you can simply run setup.sh which internally execute the scripts above 
```
./setup.sh
```

## Run spider and Test

First, change directory to craigslist_spider, then start running and qutote spider like this. The spider will collect all Jobs in Tokyo in the craigslist site store them into DocumentDB. On the indexer side, Azure Search indexer that you created regularly crawls documents in DocumentDB and index them.  

```
cd craigslist_spider
scrapy crawl craigs_tokyo
# Or if you want to export jobs list into csv file, do like this
scrapy crawl craigs_tokyo -o result.csv
```

Finally run search test command like this, then you'll see results returned if everything goes ok
```
./search-index.sh

Start Searching Index: craigslist ....
{
    "@odata.context": "https://yoichikademo2.search.windows.net/indexes('craigslist')/$metadata#docs",
    "value": [
        {
            "@search.score": 1,
            "id": "7e29dd46-9605-412f-ba14-eb90ab8e94d8",
            "url": "https://tokyo.craigslist.jp/fbh/d/supermarket-store-is-hiring/6266357170.html",
            "title": "Supermarket Store is Hiring for Itabashi and Shinagawa Store Staff Dai",
            "address": "Tokyo",
            "description": "Supermarket Store is Hiring for Itabashi and Shinagawa Store Staff Daily Conversational Japanese is ok\nHourly Wage 1100 yen/Monthly payment + Full Transportation\nJob category Kitchen Staff / Product Display Staff\nItabashi Store :\nLocation \n東武練馬駅（とうぶねりまえき） By foot 2 Minutes\nTimings \n1: 07:00～12:00 (Per week 4 days/Per day 4 Hours〜)\nApply Here: https://nihondebaito.com/en/detail/W005394164\n2: 18:00～00:00 (Per week 4 days/Per day 4 Hours〜)\nApply Here: https://nihondebaito.com/en/detail/W005394165\nShinagawa Store:\nLocation \n品川シーサイド駅（しながわしーさいどえき） By foot 3 Minutes\nTimings \n1: 07:00～12:00 (Per week 4 days/Per day 4 Hours〜)\nApply Here: https://nihondebaito.com/en/detail/W005394166\n2: 18:00～00:00 (Per week 4 days/Per day 4 Hours〜)\nApply Here: https://nihondebaito.com/en/detail/W005394184\n*Interview infomation \ndate:8/18 (Friday) 17:30 Ikebukuro station (池袋駅) set\n**Note: We recommend you to go to the link of the job that you want to apply to confirm carefully details such as a workplace, payment, interview condition, shifts,...\nMore jobs: Visit https://nihondebaito.com/en\nIf you have any questions, please inbox us directly.",
            "compensation": "パートタイム ",
            "employment_type": "Hourly Wage 1100 yen/Monthly payment + Full Transportation"
        }
    ]
}
```
