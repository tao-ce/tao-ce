function(setup)
{
    ['%(pfx)stao-dynamic-query-api-env' % setup]: {
        DEBUG: "true",
        ELASTICSEARCH_URL: setup.dependencies.es.address.url,
        FIRESTORE_PROJECT_ID: self.GOOGLE_CLOUD_PROJECT,
        FIRESTORE_EMULATOR_HOST: setup.dependencies.firestore.address.endpoint,
        FIRESTORE_HIERARCHY_BE_COLLECTION: "hierarchies",
        FIRESTORE_ROOT_COLLECTION: "oat-dev",
        FIRESTORE_ROOT_DOC: "stores",
        GCP_PROJECT_ID: self.GOOGLE_CLOUD_PROJECT,
        GOOGLE_CLOUD_PROJECT: setup.env.GOOGLE_CLOUD_PROJECT,
        HIERARCHY_API_URL: "http://tao-ce-hierarchy-be:3001",
        LOG_LEVEL: "trace",
        REQUEST_SIZE_LIMIT: "100Mb",
        FIRESTORE_HIERARCHY_WATCH_ENABLED: "true",
    },
}