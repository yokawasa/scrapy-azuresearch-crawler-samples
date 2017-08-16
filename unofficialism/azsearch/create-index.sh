#!/bin/sh

#-------------------------------------------------------
# Create Azure Search Index
# https://docs.microsoft.com/en-us/rest/api/searchservice/create-index
#-------------------------------------------------------

cwd=`dirname "$0"`
expr "$0" : "/.*" > /dev/null || cwd=`(cd "$cwd" && pwd)`
. $cwd/azure.conf

echo "Start Creating Index: $AZURE_SEARCH_INDEX_NAME ...."

APIURI="https://$AZURE_SEARCH_SERVICE_NAME.search.windows.net/indexes"
curl -s\
 -H "Content-Type: application/json"\
 -H "api-key: $AZURE_SEARCH_ADMIN_KEY"\
 -XPOST "$APIURI?api-version=$AZURE_SEARCH_API_VER" \
 -d"{
    \"name\": \"$AZURE_SEARCH_INDEX_NAME\",
    \"fields\": [
        {\"name\":\"id\", \"type\":\"Edm.String\", \"key\":true, \"retrievable\":true, \"searchable\":false, \"filterable\":false, \"sortable\":false, \"facetable\":false},
        {\"name\":\"url\", \"type\":\"Edm.String\", \"retrievable\":true, \"searchable\":false, \"filterable\":false, \"sortable\":false, \"facetable\":false},
        {\"name\":\"title\", \"type\":\"Edm.String\", \"retrievable\":true, \"searchable\":true, \"filterable\":false, \"sortable\":false, \"facetable\":false, \"analyzer\":\"ja.lucene\"},
        {\"name\":\"content\", \"type\":\"Edm.String\", \"retrievable\":true, \"searchable\":true, \"filterable\":false, \"sortable\":false, \"facetable\":false, \"analyzer\":\"ja.lucene\"},
        {\"name\":\"date\", \"type\":\"Edm.String\", \"retrievable\":true, \"searchable\":false, \"filterable\":true, \"sortable\":true, \"facetable\":true}
     ]
}"
