function(setup)
{
 ["%(pfx)stao-hierarchy-be-env" % setup]: {     DEBUG: '1',
  LOG_LEVEL: 'debug',
  NODE_ENV: 'production',
  PORT: '3001',
  ELASTICSEARCH_URL: setup.dependencies.es.address.url,
  ELASTICSEARCH_PREFIX: '',
  LOG_TYPE: 'file',
  SIDECAR_API_URL: 'http://tao-ce-em-auth-server:8888',
  DYNAMIC_API_URL: 'http://tao-ce-tao-dynamic-query-api:3000',
  GCP_PROJECT_ID: self.GOOGLE_CLOUD_PROJECT,
  GOOGLE_CLOUD_PROJECT: setup.env.GOOGLE_CLOUD_PROJECT,
  GCLOUD_PROJECT: self.GOOGLE_CLOUD_PROJECT,
  FIRESTORE_ROOT_COLLECTION: 'oat-dev',
  FIRESTORE_ROOT_DOC: 'stores',
  FIRESTORE_HIERARCHY_BE_COLLECTION: 'hierarchies',
  FIRESTORE_EMULATOR_HOST: setup.dependencies.firestore.address.endpoint,
  FIRESTORE_PROJECT_ID: self.GOOGLE_CLOUD_PROJECT,
}
}