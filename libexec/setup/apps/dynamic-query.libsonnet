function(setup)
  {
    env: {
      api: {
        OTEL_SDK_ENABLED: 'false',
        DEBUG: 'false',
        ELASTICSEARCH_URL: setup.dependencies.es.address.url,
        GCP_PROJECT_ID: self.GOOGLE_CLOUD_PROJECT,
        GOOGLE_CLOUD_PROJECT: setup.env.GOOGLE_CLOUD_PROJECT,
        HIERARCHY_API_URL: setup.apps['environment-management'].auth_server.http.url,
        AUTH_SERVER_API_URL: setup.apps['environment-management'].auth_server.http.url,
        DOCUMENT_CONVERSION_API_URL: 'http://0.0.0.0:0',
        TEST_RUNNER_API_URL: 'http://0.0.0.0:0',
        LOG_LEVEL: 'info',
        REQUEST_SIZE_LIMIT: '100Mb',
        FIRESTORE_HIERARCHY_WATCH_ENABLED: 'false',

        PORT: setup.apps.dynamic_query.api.http.port,
      },
    },
    files: {},
  }

