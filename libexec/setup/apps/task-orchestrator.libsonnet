function(setup)
  {
    local this = self,
    healthchecks+: {}
                   + this.fn.healthchecks.http('backend', 'http', path='/api/v1/health')
                   + this.fn.healthchecks.tcp('backend', 'socket')
    ,
    env: {
      backend: {
        OTEL_SDK_ENABLED: 'false',
        ADMIN_CLIENT_SECRET: setup.lib.hash('admin'),
        AUTH_SERVER_API_URL: setup.apps['environment-management'].auth_server.http.url,
        DEBUG: 'false',
        DYNAMIC_API_URL: setup.apps.dynamic_query.api.http.url,
        ELASTICSEARCH_URL: setup.dependencies.es.address.url,
        EMAIL_SUBSCRIPTION_PORTAL_DOMAIN: setup.publicDomain,
        EMAIL_SUBSCRIPTION_TOKEN_SECRET: setup.lib.hash('task-orchestrator/env/EMAIL_SUBSCRIPTION_TOKEN_SECRET'),
        FIRESTORE_EMULATOR_HOST: setup.dependencies.firestore.address.endpoint,
        FIRESTORE_PROJECT_ID: setup.env.GOOGLE_CLOUD_PROJECT,
        FIRESTORE_DATABASE_ID: 'default',
        NODE_CONFIG: 'production',
        NODE_ENV: 'production',
        GCP_PROJECT_ID: setup.env.GOOGLE_CLOUD_PROJECT,
        GCP_PUBSUB_EMAIL_SERVICE_TOPIC_NAME: 'tao-templates-email-topic',
        GCP_PUBSUB_TASK_ORCHESTRATOR_SUBSCRIPTION_NAME: 'task-orchestrator-ds',
        GCP_PUBSUB_TASK_ORCHESTRATOR_TOPIC_NAME: 'task-orchestrator-topic',
        JWKS_URL: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
        LOG_LEVEL: 'info',
        PORT: setup.apps.task_orchestrator.backend.http.port,
        PUBSUB_EMULATOR_HOST: setup.dependencies.pubsub.address.url,
        SIDECAR_API_URL: setup.apps['environment-management'].auth_server.grpc.url,
        SOCKET_PORT: setup.apps.task_orchestrator.backend.socket.port,
        TASK_ORCHESTRATOR_FIRESTORE_COLLECTION: setup.env.GOOGLE_APP_NAMESPACE,
        TASK_ORCHESTRATOR_FIRESTORE_STORAGE: 'task-orchestrator-storage',
        TENANT_API_URL: setup.apps['environment-management'].auth_server.gw.url,
      },
    },
    files: {},

    pubsub: [
      { topic: 'task-orchestrator-topic', subscription: 'task-orchestrator-ds' },
      { topic: 'tao-templates-email-topic', subscription: 'tao-templates-email-ds' },
    ],
  }
