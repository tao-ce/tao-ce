function(setup)
    local pipelines = {
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
        };
{
    files: {},

env: {
    

    worker: {
        ELASTICSEARCH_URL: setup.dependencies.es.address.url,
        GCP_PROJECT_ID: setup.env.GOOGLE_CLOUD_PROJECT,
        FIRESTORE_PROJECT_ID: setup.env.GOOGLE_CLOUD_PROJECT,
        FIRESTORE_HOST: setup.dependencies.firestore.address.host,
        IS_GCP_BUCKET_DISABLED: 'true',
        OTEL_SDK_ENABLED: 'false',
        DATASTORE_CONFIG_SOURCE_PATH: './config/',
        REDIS_HOST: setup.dependencies.redis.address.host,
        REDIS_PORT: setup.dependencies.redis.address.port,
        PUBSUB_EMULATOR_HOST:  setup.dependencies.pubsub.address.url,
        PUBSUB_TASK_ORCHESTRATOR_TOPIC_NAME: "task-orchestrator-topic",
        PUBSUB_USER_DATA_MERGED_TOPIC_NAME: 'tao-diploma-generation-user-data-merged-events-topic',
        DEBUG: 'false',
    },
} + std.foldl(
        function(t,x) t + { [x.x]: {
            ENTITY: x.x,
            SUBSCRIPTION_NAME: pipelines[x.x],
            START_COOLDOWN: 0.5 * x.i,
        }},
        std.mapWithIndex(function(i,x)  {i: i, x: x}, std.objectFields(pipelines),),
        {}),

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