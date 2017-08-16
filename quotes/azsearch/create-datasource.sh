#!/bin/sh

#-------------------------------------------------------
# Create DataSource
# https://docs.microsoft.com/en-us/azure/search/search-howto-index-documentdb
#-------------------------------------------------------

cwd=`dirname "$0"`
expr "$0" : "/.*" > /dev/null || cwd=`(cd "$cwd" && pwd)`
. $cwd/azure.conf

echo "Start Creating DataSource: $AZURE_SEARCH_INDEXER_DATASOURCE_NAME ...."

APIURI="https://$AZURE_SEARCH_SERVICE_NAME.search.windows.net/datasources"
curl -s \
 -H "Content-Type: application/json" \
 -H "api-key: $AZURE_SEARCH_ADMIN_KEY" \
 -XPOST "$APIURI?api-version=$AZURE_SEARCH_API_VER" \
 -d"{
    \"name\": \"$AZURE_SEARCH_INDEXER_DATASOURCE_NAME\",
    \"type\": \"documentdb\",
    \"credentials\": {
        \"connectionString\": \"AccountEndpoint=$DOCDB_HOST;AccountKey=$DOCDB_MASTER_KEY;Database=$DOCDB_DB\"
    },
    \"container\": {
        \"name\": \"$DOCDB_COLLECTION\",
        \"query\": \"SELECT s.id, s.text, s.author, s._ts FROM Sessions s WHERE s._ts > @HighWaterMark\"
    },
    \"dataChangeDetectionPolicy\": {
        \"@odata.type\": \"#Microsoft.Azure.Search.HighWaterMarkChangeDetectionPolicy\",
        \"highWaterMarkColumnName\": \"_ts\"
    },
    \"dataDeletionDetectionPolicy\": {
        \"@odata.type\": \"#Microsoft.Azure.Search.SoftDeleteColumnDeletionDetectionPolicy\",
        \"softDeleteColumnName\": \"isDeleted\",
        \"softDeleteMarkerValue\": \"true\"
    }
}"

