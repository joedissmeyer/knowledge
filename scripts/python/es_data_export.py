# Script to export data from an Elasticsearch cluster.
# Run from shell.
# Highly recommended to update the query string to some type of limited value on line 26.

# All data is stored directly local on disk. All data will be in the JSON format exported from Elasticsearch.

# Arguments are listed below.

import argparse, json, sys
from elasticsearch import Elasticsearch
from elasticsearch.helpers import scan

parser = argparse.ArgumentParser()
parser.add_argument("--es_host", default="localhost:9200", help="ES Connection String")
parser.add_argument("--es_user", default="elastic", help="ES User")
parser.add_argument("--es_password", default="changeme", help="ES Password")
parser.add_argument("--index", help="Index to Export", required=True)
parser.add_argument("--type", help="Type to Export", default=None)
parser.add_argument("--use_ssl", help="Use SSL", default=False, type=bool)
parser.add_argument("--max_docs_per_file", help="Max Documents in a File", default=100000, type=int)
parser.add_argument("--max_docs", help="Max Documents to Export", default=sys.maxsize, type=int)
options = parser.parse_args()

client = Elasticsearch(hosts=[options.es_host], http_auth=(options.es_user, options.es_password), use_ssl=options.use_ssl,
                           timeout=300)

# Modify this query to match exactly what you are trying to export!
# This is the most important part of the script. You basically perform a "search" for the data you want to export.
# The output of the search will be stored to local files where the script is executed.
query = {
    "query_string": {
            "query": "*",
            "analyze_wildcard": True
          }
}
try:
    cluster = client.info()
except:
    print("Cluster not accessible %s")
    sys.exit(1)

c = 0
i = 0
t = 0
index = options.index
file = open(index+"_%s"%c,"w")
for doc in scan(client,query={"query": query},index=index,doc_type=options.type):
    file.write(json.dumps(doc["_source"])+"\n")
    i+=1
    t+=1
    if i > options.max_docs_per_file:
        c+=1
        i = 0
        file.close()
        file = open(index+"_%s"%c,"w")
    if t == options.max_docs:
        print("Max Doc Limit reached of %s"% t)
        sys.exit(0)
