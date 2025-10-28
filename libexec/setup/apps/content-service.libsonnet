function(setup)
{
  env: {
    backend: {
      PORT: setup.apps['content-service'].backend.http.port,
      DEBUG: 'true',
      ELASTICSEARCH_URL: setup.dependencies.es.address.url,
      ELASTICSEARCH_INDEX: 'asset',
      ELASTICSEARCH_SYNC_REFRESH: 'true',
      STORAGE_TYPE: 'file',
      STORAGE_FILE_ROOT_PATH: '%s/content-service/data' % setup.dirs.varlib,
      STORAGE_FILE_BASE_URL: 'https://%s/content-service-storage' % setup.publicDomain
   }
  },
  files: {},
  pubsub: []
}