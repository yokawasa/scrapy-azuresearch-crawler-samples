# -*- coding: utf-8 -*-

import sys
import pydocumentdb.documents as documents
import pydocumentdb.document_client as document_client
import pydocumentdb.errors as errors
import pydocumentdb.http_constants as http_constants

def docdb_init_create(docdb_host, docdb_mkey, docdb_db, docdb_coll):
    # create documentDb client instance
    client = document_client.DocumentClient(docdb_host,
                                 {'masterKey': docdb_mkey})
    # create a database if not yet created
    database_definition = {'id': docdb_db }
    databases = list(client.QueryDatabases({
        'query': 'SELECT * FROM root r WHERE r.id=@id',
        'parameters': [
            { 'name':'@id', 'value': database_definition['id'] }
         ]
    }))
    feeddb = None
    if ( len(databases) > 0 ):
        feeddb = databases[0]
    else:
        print("database is created:%s" % docdb_db)
        feeddb = client.CreateDatabase(database_definition)

    # create a collection if not yet created
    collection_definition = { 'id': docdb_coll }
    collections = list(client.QueryCollections(
        feeddb['_self'],
        {
            'query': 'SELECT * FROM root r WHERE r.id=@id',
            'parameters': [
                { 'name':'@id', 'value': collection_definition['id'] }
            ]
        }))
    feedcoll = None
    if ( len(collections) > 0 ):
        feedcoll = collections[0]
    else:
        print("collection is created:%s" % docdb_coll)
        feedcoll = client.CreateCollection(
                feeddb['_self'], collection_definition)

if __name__ == '__main__':
    argvs = sys.argv
    argc = len(argvs)
    if (argc != 5):
        print("Usage: # python {} <docdb_host> <docdb_mkey> <docdb_db> <docdb_coll>".format(argvs[0]))
        quit()
    docdb_host = argvs[1]
    docdb_mkey = argvs[2]
    docdb_db = argvs[3]
    docdb_coll = argvs[4]
    docdb_init_create(docdb_host, docdb_mkey, docdb_db, docdb_coll)
