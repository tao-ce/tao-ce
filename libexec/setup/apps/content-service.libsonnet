function(setup)
{
  env: {
    backend: {
      local drivers = std.toString({
        file: {
          type: 'filesystem',
          config: {
            rootPath: '%s/content-service/data' % setup.dirs.varlib,
            baseUrl: 'https://%s/content-service/storage' % setup.publicDomain
          }
        }
      }),
      PORT: setup.apps['content-service'].backend.http.port,
      DEBUG: 'true',
      ELASTICSEARCH_URL: setup.dependencies.es.address.url,
      ELASTICSEARCH_INDEX: 'asset',
      ELASTICSEARCH_SYNC_REFRESH: 'true',
      DRIVERS: drivers,
      DEFAULT_DRIVER: 'file',
   }
  },
  pubsub: []
}