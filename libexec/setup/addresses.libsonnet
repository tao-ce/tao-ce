local lib = import './lib.libsonnet';
local localAddress(p, schema='http') = lib.address({ schema: schema, host: 'localhost', port: p, prefix: '' });

{
  'environment-management': {
    auth_server: {
      http: localAddress(21100),  // auth-server:8080
      gw: localAddress(21101),  //auth-server:8888
      grpc: localAddress(21102, 'tcp'),  //auth-server:1888
    },
    lti_gateway: {
      http: localAddress(21103),  //lti-gw:80
    },
    envoy: {
      http: localAddress(21104),  //envoy:80
    },
    sidecar: {
      http: localAddress(21105),  //sidecar:8080
      grpc: localAddress(21106, 'tcp'),  //sidecar:18084
    },
  },
  em: self['environment-management'],
  portal: {
    backend: {
      http: localAddress(21200),  //portal-be:3000
    },
    bootstrap: {
      http: localAddress(21201),  //portal-bootstrap:3000
    },
  },
  deliver: {
    backend: {
      http: localAddress(21300),  //deliver-be:80
    },
    bootstrap: {
      http: localAddress(21301),  //deliver-bootstrap:3000
    },
  },
  construct: {
    backend: {
      http: localAddress(21304),  //construct:8080
    },
  },
  devkit: {
    backend: {
      http: localAddress(21305),  //devkit:80
    },
  },
  dynamic_query: {
    api: {
      http: localAddress(21901),  //dynamic-query-api:3000
    },
  },
  'dynamic-query': self.dynamic_query,
  task_orchestrator: {
    backend: {
      http: localAddress(21902),  //task-orchestrator:8080
      socket: localAddress(21903, 'tcp'),  //task-orchestrator:3000
    },
  },
  'task-orchestrator': self.task_orchestrator,
  timers: {
    backend: {
      http: localAddress(21904),  //timers:8080
      socket: localAddress(21905, 'tcp'),  //timers:3000
    },
  },
  proctoring: {
    frontendAuthWait: {
      http: localAddress(21501),  //pr-fe-auth-wait:3000
    },
    frontendAuthWaitApi: {
      http: localAddress(21503),  //pr-fe-auth-wait-api:8080
    },
    frontend: {
      http: localAddress(21504),  //pr-fe:3000
    },
    lti1p3Gateway: {
      http: localAddress(21506),  //pr-lti-gateway:8080
    },
    realtimeService: {
      socket: localAddress(21508, 'tcp'),  //pr-realtime-api:3000
    },
  },
  'content-service': {
    backend: {
      http: localAddress(21400),  //content-service:3000
    },
  },
  content_service: self['content-service'],
  scoring: {
    backend: {
      http: localAddress(21601),  //ms-be:8080
    },
    frontend: {
      bootstrap: localAddress(21604),  //ms-fe:80
    },
    service: {
      http: localAddress(21608),  //ss-be:8080
    },
  },
}
