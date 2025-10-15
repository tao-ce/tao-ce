function(setup)
{
  "overload_manager": {
    "resource_monitors": [
      {
        "name": "envoy.resource_monitors.global_downstream_max_connections",
        "typed_config": {
          "@type": "type.googleapis.com/envoy.extensions.resource_monitors.downstream_connections.v3.DownstreamConnectionsConfig",
          "max_active_downstream_connections": 200
        }
      }
    ]
  },
  "static_resources": {
    "clusters": [
      {
        "connect_timeout": "1s",
        "dns_failure_refresh_rate": {
          "base_interval": "1s",
          "max_interval": "5s"
        },
        "http2_protocol_options": {},
        "load_assignment": {
          "cluster_name": "ext_proc",
          "endpoints": [
            {
              "lb_endpoints": [
                {
                  "endpoint": {
                    "address": {
                      "socket_address": {
                        "address": setup.apps["environment-management"].sidecar.grpc.host,
                        "port_value": setup.apps["environment-management"].sidecar.grpc.port,
                      }
                    }
                  }
                }
              ]
            }
          ]
        },
        "name": "ext_proc",
        "type": "strict_dns"
      },
      {
        "connect_timeout": "1s",
        "dns_failure_refresh_rate": {
          "base_interval": "1s",
          "max_interval": "5s"
        },
        "lb_policy": "round_robin",
        "load_assignment": {
          "cluster_name": "nextgen_tao_portal_be_cluster",
          "endpoints": [
            {
              "lb_endpoints": [
                {
                  "endpoint": {
                    "address": {
                      "socket_address": {
                        "address": setup.apps.portal.backend.http.host,
                        "port_value": setup.apps.portal.backend.http.port,
                      }
                    }
                  }
                }
              ]
            }
          ]
        },
        "name": "nextgen_tao_portal_be_cluster",
        "type": "strict_dns"
      },
      {
        "connect_timeout": "1s",
        "dns_failure_refresh_rate": {
          "base_interval": "1s",
          "max_interval": "5s"
        },
        "lb_policy": "round_robin",
        "load_assignment": {
          "cluster_name": "nextgen_tao_deliver_be_cluster",
          "endpoints": [
            {
              "lb_endpoints": [
                {
                  "endpoint": {
                    "address": {
                      "socket_address": {
                        "address": setup.apps.deliver.backend.http.host,
                        "port_value": setup.apps.deliver.backend.http.port,
                      }
                    }
                  }
                }
              ]
            }
          ]
        },
        "name": "nextgen_tao_deliver_be_cluster",
        "type": "strict_dns"
      },
      {
        "connect_timeout": "1s",
        "dns_failure_refresh_rate": {
          "base_interval": "1s",
          "max_interval": "5s"
        },
        "lb_policy": "round_robin",
        "load_assignment": {
          "cluster_name": "nextgen_tao_dynamic_query_api_be_cluster",
          "endpoints": [
            {
              "lb_endpoints": [
                {
                  "endpoint": {
                    "address": {
                      "socket_address": {
                        "address": setup.apps.dynamic_query.api.http.host,
                        "port_value": setup.apps.dynamic_query.api.http.port,
                      }
                    }
                  }
                }
              ]
            }
          ]
        },
        "name": "nextgen_tao_dynamic_query_api_be_cluster",
        "type": "strict_dns"
      },
      {
        "connect_timeout": "1s",
        "dns_failure_refresh_rate": {
          "base_interval": "1s",
          "max_interval": "5s"
        },
        "lb_policy": "round_robin",
        "load_assignment": {
          "cluster_name": "nextgen_tao_node_auth_server_be_cluster",
          "endpoints": [
            {
              "lb_endpoints": [
                {
                  "endpoint": {
                    "address": {
                      "socket_address": {
                        "address": setup.apps["environment-management"].auth_server.http.host,
                        "port_value": setup.apps["environment-management"].auth_server.http.port,
                      }
                    }
                  }
                }
              ]
            }
          ]
        },
        "name": "nextgen_tao_node_auth_server_be_cluster",
        "type": "strict_dns"
      }
    ],
    "listeners": [
      {
        "address": {
          "socket_address": {
            // "address": setup.apps["environment-management"].envoy.http.host,
            "address": "::", //TODO fix
            "port_value": setup.apps["environment-management"].envoy.http.port,
            "protocol": "TCP"
          },
        },
        "filter_chains": [
          {
            "filters": [
              {
                "name": "envoy.filters.network.http_connection_manager",
                "typed_config": {
                  "@type": "type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager",
                  "codec_type": "auto",
                  "http_filters": [
                    {
                      "name": "envoy.filters.http.ext_proc",
                      "typed_config": {
                        "@type": "type.googleapis.com/envoy.extensions.filters.http.ext_proc.v3.ExternalProcessor",
                        "failure_mode_allow": false,
                        "grpc_service": {
                          "envoy_grpc": {
                            "cluster_name": "ext_proc"
                          }
                        },
                        "message_timeout": "5s",
                        "processing_mode": {
                          "request_body_mode": "BUFFERED",
                          "request_header_mode": "SEND",
                          "request_trailer_mode": "SKIP",
                          "response_body_mode": "NONE",
                          "response_header_mode": "SEND",
                          "response_trailer_mode": "SKIP"
                        }
                      }
                    },
                    {
                      "name": "envoy.filters.http.router",
                      "typed_config": {
                        "@type": "type.googleapis.com/envoy.extensions.filters.http.router.v3.Router"
                      }
                    }
                  ],
                  "route_config": {
                    "name": "local_route",
                    "virtual_hosts": [
                      {
                        "domains": [
                          setup.publicDomain
                        ],
                        "name": "nextgen_vs",
                        "routes": [

                          {
                            "match": {
                              "prefix": "/portal-be/"
                            },
                            "route": {
                              "cluster": "nextgen_tao_portal_be_cluster",
                              "prefix_rewrite": "/"
                            }
                          },
                          {
                            "match": {
                              "prefix": "/deliver/"
                            },
                            "route": {
                              "cluster": "nextgen_tao_deliver_be_cluster",
                              "prefix_rewrite": "/"
                            }
                          },
                          {
                            "match": {
                              "prefix": "/dynamic-api/"
                            },
                            "route": {
                              "cluster": "nextgen_tao_dynamic_query_api_be_cluster",
                              "prefix_rewrite": "/"
                            }
                          },
                          {
                            "match": {
                              "prefix": "/auth-server/"
                            },
                            "route": {
                              "cluster": "nextgen_tao_node_auth_server_be_cluster",
                              "prefix_rewrite": "/"
                            }
                          }
                        ]
                      }
                    ]
                  },
                  "stat_prefix": "ingress_http"
                }
              }
            ]
          }
        ],
        "per_connection_buffer_limit_bytes": 52428800
      }
    ]
  }
}
