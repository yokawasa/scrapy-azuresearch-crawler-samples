#!/bin/sh

cwd=`dirname "$0"`
expr "$0" : "/.*" > /dev/null || cwd=`(cd "$cwd" && pwd)`
. $cwd/azure.conf

echo "Start Creating DocumentDB DB: $DOCDB_DB and Collection: $DOCDB_COLLECTION  ...."

python $cwd/docdb-init-create.py $DOCDB_HOST $DOCDB_MASTER_KEY $DOCDB_DB $DOCDB_COLLECTION
