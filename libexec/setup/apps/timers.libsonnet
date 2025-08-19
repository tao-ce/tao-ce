function(setup)
{
  env: {
    backend: {
      FIRESTORE_EMULATOR_HOST: setup.dependencies.firestore.address.endpoint,
      FIRESTORE_PROJECT_ID: setup.env.GOOGLE_CLOUD_PROJECT,
      LOG_LEVEL: "trace",
      MESSENGER_ASSESSMENT_LOG_TRANSPORT_DSN: "gps://default?client_config[apiEndpoint]=%s&max_messages_pull=10&topic[name]=assessment-log" % setup.dependencies.pubsub.address.url,
      PUBSUB_EMULATOR_HOST: setup.dependencies.pubsub.address.url,
      PUBSUB_PROJECT_ID: setup.env.GOOGLE_CLOUD_PROJECT,
      SIDECAR_URL: setup.apps["environment-management"].auth_server.gw.url,
      TIMERS_FIRESTORE_COLLECTION: "oat-dev",
      TIMERS_JWKS_URL: "%s/.well-known/jwks.json" % setup.apps["environment-management"].auth_server.http.url,

      TIMERS_PORT: setup.apps.timers.backend.http.port,
      TIMERS_SOCKET_PORT: setup.apps.timers.backend.socket.port,
    }

  },
  files: {},
  pubsub: [
        {"topic": "assessment-log", "subscription": "assessment-log-ds"},
  ]
}