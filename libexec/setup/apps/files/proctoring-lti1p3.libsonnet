function(setup)
    {
        lti1p3: {
            key_chains: {
                primaryKeyPair: {
                    key_set_name: 'primaryKeySet',
                    public_key: 'file://%oauth2_public_key_path%',
                    private_key: 'file://%oauth2_private_key_path%',
                    private_key_passphrase: '%oauth2_private_key_pass_phrase%',
                },
                oatInternal: {
                    key_set_name: 'oatInternal',
                    public_key: 'file://%oauth2_public_key_path%',
                    private_key: 'file://%oauth2_private_key_path%',
                    private_key_passphrase: '%oauth2_private_key_pass_phrase%',
                },
            },
            platforms: {
                portal_platform: {
                    name: 'Portal LTI platform',
                    audience: 'https://%s/portal-be' % [setup.publicDomain],
                    oauth2_access_token_url: '%s/v1/oauth2/tokens' % setup.apps['environment-management'].auth_server.http.url,
                    oidc_authentication_url: 'http://foo.bar',
                },
            },
            registrations: {
                deliver__proctoring: {
                    client_id: 'deliver-proctoring-client-id',
                    deployment_ids: ['1'],
                    platform: 'portal_platform',
                    platform_jwks_url: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
                    platform_key_chain: 'primaryKeyPair',
                    tool: 'proctoring_tool',
                    tool_jwks_url: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
                    tool_key_chain: 'primaryKeyPair',
                },
            },
            tools: {
                proctoring_tool: {
                    name: 'Proctoring tool',
                    audience: 'https://%s/pr-lti-gateway' % [setup.publicDomain],
                    oidc_initiation_url: 'https://%s/auth-server/lti1p3/oidc/initiation' % setup.publicDomain,
                    launch_url: 'https://%s/pr-lti-gateway/api/v1/actions/proctoring/start' % [setup.publicDomain],
                    deep_linking_url: '',
                },
            },
        },
    }
