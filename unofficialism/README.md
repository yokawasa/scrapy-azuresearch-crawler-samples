# Unofficialism Spider 

Web Scraping [Unofficialism](http://unofficialism.info/)'s all blog articles with [Scrapy](https://scrapy.org/) and indexing them with Azure Search

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
LOG_FILE = '/tmp/scrapy-unofficialismspider.log'

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
AZURE_SEARCH_INDEX_NAME='unofficialism'
AZURE_SEARCH_INDEXER_NAME='unofficialismindexer'
AZURE_SEARCH_INDEXER_DATASOURCE_NAME='docdbds-unofficialism'
DOCDB_HOST='https://yoichikademo1.documents.azure.com:443/'
DOCDB_DB='feeddb'
DOCDB_COLLECTION='unofficialismcoll'
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

First, change directory to unofficialismspider, then start running and qutote spider like this. The spider will collect all blog articles in the site store them into DocumentDB. On the indexer side, Azure Search indexer that you created regularly crawls documents in DocumentDB and index them.  

```
cd unofficialismspider
scrapy crawl unofficialism
# Or if you want to export jobs list into csv file, do like this
scrapy crawl unofficialism -o result.csv
```

Finally run search test command like this, then you'll see results returned if everything goes ok
```
./search-index.sh

Start Searching Index: unofficialism ....
{
    "@odata.context": "https://yoichikademo2.search.windows.net/indexes('unofficialism')/$metadata#docs",
    "value": [
        {
            "@search.score": 0.041373257,
            "id": "afcdb323-6bbc-45b5-a06b-7193966d2e36",
            "url": "http://unofficialism.info/posts/putting-wikipedia-data-into-azure-search/",
            "title": "Wikipediaデータベースを元にAzure Searchインデックスを生成する",
            "content": "\n\nWikipediaデータベースを元にAzure Searchインデックスを生成する\nWikipediaのコンテンツは Creative Commons Licenseおよび GNU Free Documentation Licenseの下にライセンスされておりWikipedia財団は再配布や再利用のために惜しげもなくこの貴重なデータベースのダンプファイル（XMLファイル）を一般提供している。全文検索の検証で大量のデータが必要なときこのWikipediaのような生きたデータを使えるのは非常に有りがたい。...",
            "date": "2015-06-09"
        }
    ]
}
```
