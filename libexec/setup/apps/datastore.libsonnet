function(setup)

{
    files: {},

env: {
    

    worker: {
        ELASTICSEARCH_URL: setup.dependencies.es.address.url,
        GCP_PROJECT_ID: setup.env.GOOGLE_CLOUD_PROJECT,
        FIRESTORE_PROJECT_ID: setup.env.GOOGLE_CLOUD_PROJECT,
        FIRESTORE_HOST: setup.dependencies.firestore.address.host,
        IS_GCP_BUCKET_DISABLED: 'true',
        DATASTORE_CONFIG_SOURCE_PATH: '/app/config/',
        PUBSUB_EMULATOR_HOST:  setup.dependencies.pubsub.address.url,
        PUBSUB_TASK_ORCHESTRATOR_TOPIC_NAME: "task-orchestrator-topic",
        PUBSUB_USER_DATA_MERGED_TOPIC_NAME: 'tao-diploma-generation-user-data-merged-events-topic',
        DEBUG: 'true',
    },
} + std.mapWithKey(
        function(k,v) {
            ENTITY: k,
            SUBSCRIPTION_NAME: v,
        },
        {
            DELIVERY_RESULTS: "delivery-results-ds",
            DELIVERY_EXECUTIONS: "delivery-execution-ds",
            ACS_ACTIONS: "acs-log",
            ASSESSMENT_ACTIONS: "assessment-log-ds",
            DELIVERIES: "deliveries-ds",
            MANUAL_DELIVERY_RESULTS: "manual-delivery-results-ds",
            UI_EVENTS: "ui-events-ds",
            PROCTOR_ACTIONS: "proctor-action",
            ACTIVITY_LOGS: "activity-logs-ds",
            DELIVERY_PUBLICATION: "publication-datastore-subscription",
            USERS: "users-ds",
        }),

    pubsub: [
    {"topic": "delivery-topic", "subscription": "deliveries-ds"},
    {"topic": "delivery-results-ds", "subscription": "delivery-results-ds"},
    {"topic": "ui-events-topic", "subscription": "ui-events-ds"},
    {"topic": "proctor-action", "subscription": "proctor-action"},
    {"topic": "grader-manual-results-topic", "subscription": "manual-delivery-results-ds"},
    {"topic": "task-orchestrator-topic", "subscription": "task-orchestrator-ds"},
    {"topic": "start-export-csv-topic", "subscription": "start-export-csv-ds"},
    {"topic": "assessment-log", "subscription": "assessment-log-ds"},
    {"topic": "activity-logs-topic", "subscription": "activity-logs-ds"},
    {"topic": "metadata-propagation-topic", "subscription": "metadata-propagation-ds"},
    {"topic": "tao-templates-email-topic", "subscription": "tao-templates-email-ds"},
    {"topic": "users-ds", "subscription": "users-ds"},
    {"topic": "grader-publications-topic", "subscription": "publication-datastore-subscription"},
    {"topic": "datastore", "subscription": "datastore"},
    {"topic": "acs-log", "subscription": "acs-log"},
    {"topic": "delivery-execution", "subscription": "delivery-execution-ds"},

    ]
}