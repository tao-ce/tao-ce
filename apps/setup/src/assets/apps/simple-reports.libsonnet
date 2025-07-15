function(setup)
{
    ['%(pfx)stao-simple-reports-be-env' % setup]: {
        APP_ENV: 'prod',
        APP_SECRET: '4943e7a4c8a6a3c8bcf2a139b18961ea',
        DATABASE_URL: 'pgsql://postgres:postgres@%s/simple_reports' % setup.dependencies.pgsql.address.endpoint,
        EM_SIDECAR_HOST: "tao-ce-em-auth-server",
        EM_SIDECAR_PORT: '1888',
        EM_AUTH_SERVER_GRPC_GATEWAY_HOST: 'http://tao-ce-em-auth-server:8888',
        DYNAMIC_QUERY_API_BASE_URL: 'http://tao-ce-tao-dynamic-query-api:3000',
        DYNAMIC_QUERY_API_GATEWAY_TIMEOUT: '100',
        CORS_ALLOW_ORIGIN: '*',
    },
}