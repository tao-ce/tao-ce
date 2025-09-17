function(setup)
{
 env: {
    backend: {
  DEBUG: '1',
  LOG_LEVEL: 'debug',
  NODE_ENV: 'production',
  PORT: setup.apps.hierarchy.backend.http.port,
  ELASTICSEARCH_URL: setup.dependencies.es.address.url,
  ELASTICSEARCH_PREFIX: '',
  LOG_TYPE: 'file',
  SIDECAR_API_URL: setup.apps["environment-management"].auth_server.grpc.url,
  DYNAMIC_API_URL: setup.apps.dynamic_query.api.http.url,
  GCP_PROJECT_ID: self.GOOGLE_CLOUD_PROJECT,
  GOOGLE_CLOUD_PROJECT: setup.env.GOOGLE_CLOUD_PROJECT,
  GCLOUD_PROJECT: self.GOOGLE_CLOUD_PROJECT,
  FIRESTORE_ROOT_COLLECTION: 'oat-dev',
  FIRESTORE_ROOT_DOC: 'stores',
  FIRESTORE_HIERARCHY_BE_COLLECTION: 'hierarchies',
  FIRESTORE_EMULATOR_HOST: setup.dependencies.firestore.address.endpoint,
  FIRESTORE_PROJECT_ID: self.GOOGLE_CLOUD_PROJECT,
}
 },
 files: {}
}