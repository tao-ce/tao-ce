function(setup)
{
   ['%(pfx)srt-timers-env' % setup]: {
  FIRESTORE_EMULATOR_HOST: setup.dependencies.firestore.address.endpoint,
  FIRESTORE_PROJECT_ID: setup.env.GOOGLE_CLOUD_PROJECT,
  LOG_LEVEL: "trace",
  MESSENGER_ASSESSMENT_LOG_TRANSPORT_DSN: "gps://default?client_config[apiEndpoint]=%s&max_messages_pull=10&topic[name]=assessment-log" % setup.dependencies.pubsub.address.url,
  PUBSUB_EMULATOR_HOST: setup.dependencies.pubsub.address.url,
  PUBSUB_PROJECT_ID: setup.env.GOOGLE_CLOUD_PROJECT,
  SIDECAR_URL: "http://tao-ce-em-auth-server:8888",
  TIMERS_FIRESTORE_COLLECTION: "oat-dev",
  TIMERS_JWKS_URL: "http://tao-ce-em-auth-server:8080/.well-known/jwks.json",
   }, 
}