function(setup)
  {
    env: {
      backend: {
        COMPOSER_AUTH: '{"http-basic":{"github.com":{"username":"${GITHUB_USERNAME}","password":"${GITHUB_TOKEN}"}}}',
        APP_ENV: 'dev',
        APP_DEBUG: if $.vm.enabled then 'false' else 'true',
        APP_HOST: setup.apps.scoring.backend.http.url,
        DATABASE_URL: 'pgsql://postgres:postgres@%(host)s:%(port)s/manual_scoring' % setup.dependencies.pgsql.address,
        CORS_ALLOW_ORIGIN: '.*',
        REDIS_CACHE_DSN: 'redis://%(host)s:%(port)s' % setup.dependencies.redis.address,

        MESSENGER_INTERNAL_DSN: 'gps://default',
        MESSENGER_INTERNAL_QUEUE_TOPIC: 'ms-internal-topic',
        MESSENGER_INTERNAL_QUEUE_SUBSCRIPTION: 'ms-internal-subscription',

        MESSENGER_FAILURES_DSN: 'gps://default',
        MESSENGER_FAILURES_QUEUE_TOPIC: 'ms-failures-topic',
        MESSENGER_FAILURES_QUEUE_SUBSCRIPTION: 'ms-failures-subscription',

        MESSENGER_GRADER_DELIVERIES_DSN: 'gps://default',
        MESSENGER_GRADER_DELIVERIES_QUEUE_TOPIC: 'grader-executions-topic',
        MESSENGER_GRADER_DELIVERIES_QUEUE_SUBSCRIPTION: 'ms-grader-deliveries-subscription',

        MESSENGER_GRADER_RESPONSES_DSN: 'gps://default',
        MESSENGER_GRADER_RESPONSES_QUEUE_TOPIC: 'grader-responses-topic',
        MESSENGER_GRADER_RESPONSES_QUEUE_SUBSCRIPTION: 'ms-grader-responses-subscription',

        MESSENGER_GRADER_SCORES_DSN: 'gps://default',
        MESSENGER_GRADER_SCORES_QUEUE_TOPIC: 'grader-scores-topic',

        MESSENGER_GRADER_STATUSES_DSN: 'gps://default',
        MESSENGER_GRADER_STATUSES_QUEUE_TOPIC: 'grader-statuses-topic',

        SCORING_PROJECT_DEFAULT_ASSIGNMENT_STRATEGY: 'item_category_based',
        SCORING_PROJECT_DEFAULT_SCORING_STRATEGY: 'single',
        SCORING_PROJECT_DEFAULT_SCORING_STRATEGY_CONFIGURATION: '{}',

        SOLAR_DELIVER_BASE_URL: setup.apps.deliver.backend.http.url,

        GOOGLE_CLOUD_PROJECT: setup.env.GOOGLE_CLOUD_PROJECT,
        PUBSUB_PROJECT_ID: setup.env.GOOGLE_CLOUD_PROJECT,
        PUBSUB_EMULATOR_HOST: setup.dependencies.pubsub.address.endpoint,

        AUTH_SERVER_BASE_URL: setup.apps['environment-management'].auth_server.http.url,
        AUTH_SERVER_TOKEN_REQUEST_PATH: '/v1/oauth2/tokens',
        AUTH_SERVER_GATEWAY_TIMEOUT: '45',
        EM_SIDECAR_HOST: setup.apps['environment-management'].auth_server.grpc.host,
        EM_SIDECAR_PORT: setup.apps['environment-management'].auth_server.grpc.port,
        EM_AUTH_SERVER_GRPC_GATEWAY_HOST: setup.apps['environment-management'].auth_server.gw.url,
        DYNAMIC_QUERY_API_URL: setup.apps.dynamic_query.api.http.url,
        AI_API_URL: setup.apps.ai.backend.http.url,
        CONTENT_API_URL: setup.apps.content.backend.http.url,
      },
      frontend: {
        API_URL: 'https://%(publicDomain)s/ms-be' % setup,
        AUTH_SERVER_URL: 'https://%(publicDomain)s/auth-server' % setup,
        REFRESH_TOKEN_URI: '/api/v1/auth/refresh-tokens',
        STATIC_URL: 'https://%(publicDomain)s/ms-fe-static' % setup,
        TENANTS: '[{"label":"tao-ce-stack","clientId":"ms-fe-solar-client-id"}]',
      },
      hbl: {
        COMPOSER_AUTH: '{"http-basic":{"github.com":{"username":"${GITHUB_USERNAME}","password":"${GITHUB_TOKEN}"}}}',
        APP_HOST: setup.apps.scoring.hbl.backend.http.url,
        DATABASE_URL: 'pgsql://postgres:postgres@%(host)s:%(port)s/hbl_scoring_engine' % setup.dependencies.pgsql.address,

        MESSENGER_DELIVERIES_DSN: 'gps://default',
        MESSENGER_DELIVERIES_QUEUE_TOPIC: 'hbl-deliveries-topic',
        MESSENGER_DELIVERIES_QUEUE_SUBSCRIPTION: 'hbl-deliveries-subscription',

        MESSENGER_STATUSES_DSN: 'gps://default',
        MESSENGER_STATUSES_QUEUE_TOPIC: 'hbl-status-topic',
        MESSENGER_STATUSES_QUEUE_SUBSCRIPTION: 'hbl-status-subscription',

        MESSENGER_FAILURES_DSN: 'gps://default',
        MESSENGER_FAILURES_QUEUE_TOPIC: 'hbl-failures-topic',
        MESSENGER_FAILURES_QUEUE_SUBSCRIPTION: 'hbl-failures-subscription',

        MESSENGER_GRADER_DELIVERIES_DSN: 'gps://default',
        MESSENGER_GRADER_DELIVERIES_QUEUE_TOPIC: 'grader-deliveries-topic',
        MESSENGER_GRADER_DELIVERIES_QUEUE_SUBSCRIPTION: 'hbl-grader-deliveries-subscription',

        MESSENGER_GRADER_RESPONSES_DSN: 'gps://default',
        MESSENGER_GRADER_RESPONSES_QUEUE_TOPIC: 'grader-responses-topic',
        MESSENGER_GRADER_RESPONSES_QUEUE_SUBSCRIPTION: 'hbl-grader-responses-subscription',

        MESSENGER_GRADER_HBL_RESULTS_DSN: 'gps://default',
        MESSENGER_GRADER_HBL_RESULTS_QUEUE_TOPIC: 'grader-hbl-results-topic-name',

        GOOGLE_CLOUD_PROJECT: setup.env.GOOGLE_CLOUD_PROJECT,
        PUBSUB_PROJECT_ID: setup.env.GOOGLE_CLOUD_PROJECT,
        PUBSUB_EMULATOR_HOST: setup.dependencies.pubsub.address.endpoint,

        REDIS_CACHE_DSN: setup.dependencies.redis.address.url,
        HBL_HOST: 'https://hbl-dev.free.beeceptor.com',
        HBL_AUTH_HOST: 'https://hbl-dev.free.beeceptor.com',
        HBL_OAUTH2_TOKEN_REQUEST_PATH: '/token',
        HBL_OAUTH2_CLIENT_ID: 'foo',
        HBL_OAUTH2_CLIENT_SECRET: 'bar',
        HBL_OAUTH2_SCOPE: 'baz',
        EM_AUTH_SERVER_GRPC_GATEWAY_HOST: setup.apps['environment-management'].auth_server.gw.url,
      },
      service: {
        COMPOSER_AUTH: '{"http-basic":{"github.com":{"username":"${GITHUB_USERNAME}","password":"${GITHUB_TOKEN}"}}}',
        APP_ENV: 'dev',
        APP_DEBUG: 'true',
        DATABASE_URL: 'pgsql://postgres:postgres@%(host)s:%(port)s/scoring_service' % setup.dependencies.pgsql.address,

        EM_SIDECAR_HOST: setup.apps['environment-management'].auth_server.grpc.host,
        EM_SIDECAR_PORT: setup.apps['environment-management'].auth_server.grpc.port,
        AUTH_SERVER_BASE_URL: setup.apps['environment-management'].auth_server.http.url,
        AUTH_SERVER_TOKEN_REQUEST_PATH: '/v1/oauth2/tokens',
        AUTH_SERVER_GATEWAY_TIMEOUT: '45',
        LTI_GATEWAY_URL: setup.apps['environment-management'].lti_gateway.http.url,

        SOLAR_DELIVER_BASE_URL: setup.apps.deliver.backend.http.url,
        SOLAR_DELIVER_OAUTH2_CLIENT_CREDENTIALS: '[{"tenantId":"1","clientId":"deliver-client-id-for-ss","clientSecret":"secret"}]' % $.config,
        SOLAR_DELIVER_GATEWAY_TIMEOUT: '45',

        TAO_BASIC_AUTH_USERNAME: 'admin',
        TAO_BASIC_AUTH_PASSWORD: 'Admin.12345',
        TAO_GATEWAY_TIMEOUT: '45',

        GOOGLE_CLOUD_PROJECT: setup.env.GOOGLE_CLOUD_PROJECT,
        PUBSUB_PROJECT_ID: setup.env.GOOGLE_CLOUD_PROJECT,
        PUBSUB_EMULATOR_HOST: setup.dependencies.pubsub.address.endpoint,
        REDIS_GCP_TOKEN_CACHE_DSN: setup.dependencies.redis.address.url,

        MESSENGER_AGS_DSN: 'gps://default',
        MESSENGER_AGS_QUEUE_TOPIC: 'ss-ags-topic',
        MESSENGER_AGS_QUEUE_SUBSCRIPTION: 'ss-ags-subscription',

        MESSENGER_SCORES_DSN: 'gps://default',
        MESSENGER_SCORES_QUEUE_TOPIC: 'ss-scores-topic',
        MESSENGER_SCORES_QUEUE_SUBSCRIPTION: 'ss-scores-subscription',

        MESSENGER_SUBMISSIONS_DSN: 'gps://default',
        MESSENGER_SUBMISSIONS_QUEUE_TOPIC: 'ss-submissions-topic',
        MESSENGER_SUBMISSIONS_QUEUE_SUBSCRIPTION: 'ss-submissions-subscription',

        MESSENGER_FAILURES_DSN: 'gps://default',
        MESSENGER_FAILURES_QUEUE_TOPIC: 'ss-failures-topic',
        MESSENGER_FAILURES_QUEUE_SUBSCRIPTION: 'ss-failures-subscription',

        MESSENGER_GRADER_DELIVERIES_DSN: 'gps://default',
        MESSENGER_GRADER_DELIVERIES_QUEUE_TOPIC: 'grader-deliveries-topic',

        MESSENGER_GRADER_RESPONSES_DSN: 'gps://default',
        MESSENGER_GRADER_RESPONSES_QUEUE_TOPIC: 'grader-responses-topic',

        MESSENGER_GRADER_EXECUTIONS_DSN: 'gps://default',
        MESSENGER_GRADER_EXECUTIONS_QUEUE_TOPIC: 'grader-executions-topic',
        MESSENGER_GRADER_EXECUTIONS_QUEUE_SUBSCRIPTION: 'ss-grader-executions-subscription',

        MESSENGER_GRADER_SCORES_DSN: 'gps://default',
        MESSENGER_GRADER_SCORES_QUEUE_TOPIC: 'grader-scores-topic',
        MESSENGER_GRADER_SCORES_QUEUE_SUBSCRIPTION: 'ss-grader-scores-subscription',

        MESSENGER_GRADER_MANUAL_RESULTS_DSN: 'gps://default',
        MESSENGER_GRADER_MANUAL_RESULTS_QUEUE_TOPIC: 'grader-manual-results-topic',

        MESSENGER_GRADER_SCORING_EVENTS_DSN: 'gps://default',
        MESSENGER_GRADER_SCORING_EVENTS_QUEUE_TOPIC: 'grader-scoring-events',

        MESSENGER_GRADER_PUBLICATIONS_DSN: 'gps://default',
        MESSENGER_GRADER_PUBLICATIONS_QUEUE_TOPIC: 'grader-publications-topic',
        MESSENGER_GRADER_PUBLICATIONS_QUEUE_SUBSCRIPTION: 'ss-grader-publications-subscription',

        DEFAULT_RESPONSE_HANDLER: '[{"engine":"manual","schedule":"* * * * *"},{"engine":"hbl","schedule":"* * * * *"}]',

        EM_AUTH_SERVER_GRPC_GATEWAY_HOST: setup.apps['environment-management'].auth_server.gw.url,
      },
    },
    files: {
    },
    pubsub: [
      { topic: 'ms-internal-topic', subscription: 'ms-internal-subscription' },
      { topic: 'ms-failures-topic', subscription: 'ms-failures-subscription' },

      { topic: 'grader-deliveries-topic', subscription: 'grader-deliveries-subscription' },
      { topic: 'grader-responses-topic', subscription: 'grader-responses-subscription' },
      { topic: 'grader-executions-topic', subscription: 'grader-executions-subscription' },
      { topic: 'grader-manual-results-topic', subscription: 'grader-manual-results-subscription' },
      { topic: 'grader-scoring-events', subscription: 'grader-scoring-events-subscription' },
      { topic: 'grader-publications-topic', subscription: 'ss-grader-publications-subscription' },
      { topic: 'grader-scores-topic', subscription: 'ss-grader-scores-subscription' },
      { topic: 'grader-statuses-topic', subscription: 'grader-statuses-subscription' },

      { topic: 'hbl-deliveries-topic', subscription: 'hbl-deliveries-subscription' },
      { topic: 'hbl-status-topic', subscription: 'hbl-status-subscription' },
      { topic: 'hbl-failures-topic', subscription: 'hbl-failures-subscription' },
      { topic: 'grader-hbl-results-topic-name', subscription: 'grader-hbl-results-subscription-name' },

      { topic: 'ss-ags-topic', subscription: 'ss-ags-subscription' },
      { topic: 'ss-scores-topic', subscription: 'ss-scores-subscription' },
      { topic: 'ss-submissions-topic', subscription: 'ss-submissions-subscription' },
      { topic: 'ss-failures-topic', subscription: 'ss-failures-subscription' },
    ],
  }
