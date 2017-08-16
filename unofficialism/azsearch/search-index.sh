#!/bin/sh

cwd=`dirname "$0"`
expr "$0" : "/.*" > /dev/null || cwd=`(cd "$cwd" && pwd)`
. $cwd/azure.conf

echo "Start Searching Index: $AZURE_SEARCH_INDEX_NAME ...."

APIURI="https://$AZURE_SEARCH_SERVICE_NAME.search.windows.net/indexes/$AZURE_SEARCH_INDEX_NAME/docs"
{
curl -s\
 -H "Content-Type: application/json" \
 -H "api-key: $AZURE_SEARCH_ADMIN_KEY" \
 -XGET "$APIURI?api-version=$AZURE_SEARCH_API_VER&search=*&\$count=true&\$top=1"
}
