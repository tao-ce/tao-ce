function(setup)
  local clusters_config = [{
    prefix: '/portal-be',
    cluster: 'portal_be',
    socket_address: {
      address: setup.apps.portal.backend.http.host,
      port_value: setup.apps.portal.backend.http.port,
    },
    whitelisted_paths: [
      '/api/v1/configuration',
      '/api/v1/emails/subscriptions/cancel',
      '/api/v1/emails/verify',
      '/api/v1/sessions/public',
      '/api/v1/users/password-reset',
      '/api/v1/lti/launch-public-delivery-execution',
      '/api/v1/health',
    ],
  },{
    prefix: '/deliver',
    cluster: 'deliver',
    socket_address: {
      address: setup.apps.deliver.backend.http.host,
      port_value: setup.apps.deliver.backend.http.port,
    },
    whitelisted_paths: [
      '/lti1p3/oidc/authentication',
      '/api/v1/asset',
      '/api/v1/attachments',
      '/api/v1/csv',
      '/api/v1/download-asset',
      '/health-check',
      '/v1/lti/platform/message/launch/lti-resource-link',
      '/v1/lti/validate-platform-launch',
      // '/api/v1/auth/launch-lti-1p3',
    ],
  },{
    prefix: '/dynamic-api',
    cluster: 'dynamic_api',
    socket_address: {
      address: setup.apps.dynamic_query.api.http.host,
      port_value: setup.apps.dynamic_query.api.http.port,
    },
  },{
    prefix: '/auth-server',
    cluster: 'auth_server',
    socket_address: {
      address: setup.apps['environment-management'].auth_server.http.host,
      port_value: setup.apps['environment-management'].auth_server.http.port,
    },
    whitelisted_paths: [
      '/.well-known/jwks.json',
      '/v1/oauth2/tokens',
      '/v1/sso/callback',
      '/v1/lti/platform/message/launch/lti-resource-link',
      '/v1/lti/validate-platform-launch',
    ]
  },{
    prefix: '/ss-be',
    cluster: 'scoring_service',
    socket_address: {
      address: setup.apps.scoring.service.http.host,
      port_value: setup.apps.scoring.service.http.port,
    },
  },{
    prefix: '/ms-be',
    cluster: 'manual_scoring',
    socket_address: {
      address: setup.apps.scoring.backend.http.host,
      port_value: setup.apps.scoring.backend.http.port,
    },
  },{
    prefix: '/pr-lti-gateway',
    cluster: 'lti13_gateway',
    socket_address: {
      address: setup.apps.proctoring.lti1p3Gateway.http.host,
      port_value: setup.apps.proctoring.lti1p3Gateway.http.port,
    },
    whitelisted_paths: [
      '/health-check',
      '/api/v1/assessments/start',
      '/api/v1/configuration',
    ],
  },
];

local whitelists_routes = function(cluster) [{
    match: { prefix: cluster.prefix + path },
    route: { cluster: cluster.cluster, prefix_rewrite: path, },
    typed_per_filter_config: { 'envoy.filters.http.ext_proc': { '@type': 'type.googleapis.com/envoy.extensions.filters.http.ext_proc.v3.ExtProcPerRoute', disabled: true, }, },
  }
  for path in std.get(cluster, 'whitelisted_paths', [])
  ];

local options_routes = function(cluster) [{
    match: { prefix: cluster.prefix + '/', headers: [ { name: ':method', exact_match: 'OPTIONS', }, ], },
    route: { cluster: cluster.cluster, prefix_rewrite: '/', },
    typed_per_filter_config: { 'envoy.filters.http.ext_proc': { '@type': 'type.googleapis.com/envoy.extensions.filters.http.ext_proc.v3.ExtProcPerRoute', disabled: true, }, },
  }];

local standard_routes = function(cluster) [{
    match: { prefix: cluster.prefix + '/' },
    route: { cluster: cluster.cluster, prefix_rewrite: '/', },
  }];


  {
    overload_manager: {
      resource_monitors: [
        {
          name: 'envoy.resource_monitors.global_downstream_max_connections',
          typed_config: {
            '@type': 'type.googleapis.com/envoy.extensions.resource_monitors.downstream_connections.v3.DownstreamConnectionsConfig',
            max_active_downstream_connections: 200,
          },
        },
      ],
    },
    static_resources: {
      clusters: [
        {
          connect_timeout: '1s',
          dns_failure_refresh_rate: {
            base_interval: '1s',
            max_interval: '5s',
          },
          http2_protocol_options: {},
          load_assignment: {
            cluster_name: 'ext_proc',
            endpoints: [
              {
                lb_endpoints: [
                  {
                    endpoint: {
                      address: {
                        socket_address: {
                          address: setup.apps['environment-management'].sidecar.grpc.host,
                          port_value: setup.apps['environment-management'].sidecar.grpc.port,
                        },
                      },
                    },
                  },
                ],
              },
            ],
          },
          name: 'ext_proc',
          type: 'strict_dns',
        },
      ] + [
        {
          connect_timeout: '1s',
          dns_failure_refresh_rate: { base_interval: '1s', max_interval: '5s', },
          lb_policy: 'round_robin',
          load_assignment: {
            cluster_name: cluster.cluster,
            endpoints: [
              {
                lb_endpoints: [ { endpoint: { address: { socket_address: cluster.socket_address, }, }, }, ],
              },
            ],
          },
          name: cluster.cluster,
          type: 'strict_dns',
        },
        for cluster in clusters_config
      ],
      listeners: [
        {
          address: {
            socket_address: {
              // "address": setup.apps["environment-management"].envoy.http.host,
              address: '::',  //TODO fix
              port_value: setup.apps['environment-management'].envoy.http.port,
              protocol: 'TCP',
            },
          },
          filter_chains: [
            {
              filters: [
                {
                  name: 'envoy.filters.network.http_connection_manager',
                  typed_config: {
                    '@type': 'type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager',
                    codec_type: 'auto',
                    http_filters: [
                      {
                        name: 'envoy.filters.http.ext_proc',
                        typed_config: {
                          '@type': 'type.googleapis.com/envoy.extensions.filters.http.ext_proc.v3.ExternalProcessor',
                          failure_mode_allow: false,
                          grpc_service: {
                            envoy_grpc: {
                              cluster_name: 'ext_proc',
                            },
                          },
                          message_timeout: '5s',
                          processing_mode: {
                            request_body_mode: 'BUFFERED',
                            request_header_mode: 'SEND',
                            request_trailer_mode: 'SKIP',
                            response_body_mode: 'NONE',
                            response_header_mode: 'SEND',
                            response_trailer_mode: 'SKIP',
                          },
                        },
                      },
                      {
                        name: 'envoy.filters.http.router',
                        typed_config: {
                          '@type': 'type.googleapis.com/envoy.extensions.filters.http.router.v3.Router',
                        },
                      },
                    ],
                    route_config: {
                      name: 'local_route',
                      virtual_hosts: [
                        {
                          domains: [ '*' ],
                          name: 'virtual_service',
                          routes: []
                          + std.foldl( function(t, c) t + options_routes(c), clusters_config, [])
                          + std.foldl( function(t, c) t + whitelists_routes(c), clusters_config, [])
                          + std.foldl( function(t, c) t + standard_routes(c), clusters_config, [])
                          ,
                        },
                      ],
                    },
                    stat_prefix: 'ingress_http',
                  },
                },
              ],
            },
          ],
          per_connection_buffer_limit_bytes: 52428800,
        },
      ],
    },
  }
