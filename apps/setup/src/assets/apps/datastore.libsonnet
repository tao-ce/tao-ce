function(setup)

{
    ['%(pfx)sdatastore-worker-env' % setup]: {
        ELASTICSEARCH_URL: setup.dependencies.es.address.url,
        GCP_PROJECT_ID: setup.env.GOOGLE_CLOUD_PROJECT,
        FIRESTORE_PROJECT_ID: setup.env.GOOGLE_CLOUD_PROJECT,
        IS_GCP_BUCKET_DISABLED: 'true',
        DATASTORE_CONFIG_SOURCE_PATH: '/app/config/',
        PUBSUB_EMULATOR_HOST:  setup.dependencies.pubsub.address.url,
        PUBSUB_TASK_ORCHESTRATOR_TOPIC_NAME: "task-orchestrator-topic",
        DEBUG: 'true',
    }
}
