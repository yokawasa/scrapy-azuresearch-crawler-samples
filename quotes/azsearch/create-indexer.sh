#!/bin/sh

#-------------------------------------------------------
# Create Indexer
# https://docs.microsoft.com/en-us/azure/search/search-howto-index-documentdb
#-------------------------------------------------------

cwd=`dirname "$0"`
expr "$0" : "/.*" > /dev/null || cwd=`(cd "$cwd" && pwd)`
. $cwd/azure.conf

echo "Start Creating Indexer: $AZURE_SEARCH_INDEXER_NAME ...."

APIURI="https://$AZURE_SEARCH_SERVICE_NAME.search.windows.net/indexers"
curl -s\
 -H "Content-Type: application/json"\
 -H "api-key: $AZURE_SEARCH_ADMIN_KEY"\
 -XPOST "$APIURI?api-version=$AZURE_SEARCH_API_VER" \
 -d"{
    \"name\": \"$AZURE_SEARCH_INDEXER_NAME\",
    \"dataSourceName\": \"$AZURE_SEARCH_INDEXER_DATASOURCE_NAME\",
    \"targetIndexName\" : \"$AZURE_SEARCH_INDEX_NAME\",
    \"schedule\":
    {
        \"interval\" : \"PT5M\",
        \"startTime\" :\"2017-08-15T00:00:00Z\"
    }
}"
