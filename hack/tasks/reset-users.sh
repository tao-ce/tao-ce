#!/bin/sh
#

ELASTICSEARCH_URL=${ELASTICSEARCH_URL:-http://es.deps:9200}

while IFS=, read index ; do
    curl -X DELETE -H 'Content-Type: application/json' ${ELASTICSEARCH_URL}/$index
    kubectl exec deploy/tao-ce-tao-portal-be -c backend -- cat mappings/${index}.json | curl -XPUT -H 'Content-Type: application/json' ${ELASTICSEARCH_URL}/$index -d @-
done <<EOS
portal-user
portal-enrolment
portal-hierarchy
portal-config-hierarchy
EOS

jsonnet lib/portal-data.jsonnet \
    | jq -c '.[]' \
    | curl -X POST \
        -H 'Content-Type: application/json' \
        --data-binary @- ${ELASTICSEARCH_URL}/_bulk?pretty

