function(setup)
  {
    lti1p3+: {
      key_chains: {
        primaryKeyPair: {
          private_key: 'file://%s/em.key' % setup.dirs.keys,
          public_key: 'file://%s/em.pub' % setup.dirs.keys,
          private_key_passphrase: '123456',
          key_set_name: 'primaryKeySet',
        },
        platformKey: {
          private_key: 'file://%s/devkit.key' % setup.dirs.keys,
          public_key: 'file://%s/devkit.pub' % setup.dirs.keys,
          private_key_passphrase: '~',
          key_set_name: 'platformSet',
        },
        toolKey: self.platformKey {
          key_set_name: 'toolSet',
        },
      },
      platforms: {
        deliver_platform+: {
          name: 'Deliver Platform',
          audience: 'https://' + setup.publicDomain + '/deliver',
          oauth2_access_token_url: '%s/lti1p3/auth/primaryKeyPair/token' % setup.apps['environment-management'].auth_server.http.url,
          oidc_authentication_url: 'https://%s/deliver/lti1p3/oidc/authentication' % setup.publicDomain,

        },
        devkit_platform+: {
          name: 'DevKit Platform',
          audience: 'https://' + setup.publicDomain + '/devkit/platform',
          oauth2_access_token_url: '%s/lti1p3/auth/primaryKeyPair/token' % setup.apps.devkit.backend.http.url,
          oidc_authentication_url: 'https://%s/devkit/lti1p3/oidc/authentication' % setup.publicDomain,

        },
      },
      registrations: {
        lti_deliver_devkit+: {
          client_id: 'lti-deliver-devkit-1',
          deployment_ids: ['1'],
          platform: 'deliver_platform',
          platform_jwks_url: '%s/lti1p3/.well-known/jwks/primaryKeySet.json' % setup.apps.devkit.backend.http.url,
          platform_key_chain: null,
          tool: 'devkit_tool',
          tool_jwks_url: '%s/lti1p3/.well-known/jwks/primaryKeySet.json' % setup.apps['environment-management'].auth_server.http.url,
          tool_key_chain: 'primaryKeyPair',
        },
        lti_devkit_deliver+: {
          client_id: 'lti-devkit-deliver-1',
          deployment_ids: ['deploymentId', '1', '2', '3'],
          order: 0,
          platform: 'devkit_platform',
          platform_jwks_url: '%s/lti1p3/.well-known/jwks/primaryKeySet.json' % setup.apps.devkit.backend.http.url,
          platform_key_chain: 'primaryKeyPair',
          tool: 'deliver_tool',
          tool_jwks_url: '%s/lti1p3/.well-known/jwks/primaryKeySet.json' % setup.apps['environment-management'].auth_server.http.url,
          tool_key_chain: 'primaryKeyPair',
        },
        lti_devkit_devkit+: {
          client_id: 'lti-devkit-devkit-1',
          deployment_ids: ['deploymentId1', 'deploymentId2'],
          platform: 'devkit_platform',
          platform_jwks_url: '%s/lti1p3/.well-known/jwks/primaryKeySet.json' % setup.apps.devkit.backend.http.url,
          tool: 'devkit_tool',
          tool_key_chain: 'primaryKeyPair',
          tool_jwks_url: self.platform_jwks_url,
        },
      },
      tools: {
        local oidc_url = 'https://%s/auth-server/lti1p3/oidc/initiation' % setup.publicDomain,
        deliver_tool+: {
          name: 'Deliver Tool',
          audience: 'https://%s/deliver' % setup.publicDomain,
          deep_linking_url: '%s/api/v1/lti/deep-links' % self.audience,
          launch_url: '%s/api/v1/auth/launch-lti-1p3/' % self.audience,
          oidc_initiation_url: oidc_url,
        },
        devkit_tool+: {
          name: 'DevKit Tool',
          audience: 'https://%s/devkit/tool' % setup.publicDomain,
          launch_url: '%s/launch' % self.audience,
          deep_linking_url: self.launch_url,
          oidc_initiation_url: 'https://%s/devkit/lti1p3/oidc/initiation' % setup.publicDomain,
        },
        manual_scoring_tool+: {
          name: 'Manual Scoring Tool',
          audience: 'https://%s/ms-be' % setup.publicDomain,
          deep_linking_url: '~',
          launch_url: '%s/api/v1/lti1p3/launch' % self.audience,
          oidc_initiation_url: oidc_url,
        },
        proctoring_tool+: {
          name: 'Proctoring Tool',
          audience: 'https://%s/pr-lti-gateway' % setup.publicDomain,
          deep_linking_url: '~',
          launch_url: '%s/api/v1/lti1p3/launch' % self.audience,
          oidc_initiation_url: oidc_url,
        },
        tao_backoffice_tool+: {
          name: 'TAO Backoffice Tool',
          audience: 'https://%s/backoffice' % setup.publicDomain,
          deep_linking_url: '~',
          launch_url: '%s/ltiDeliveryProvider/DeliveryTool/launch1p3?delivery=' % self.audience,
          oidc_initiation_url: '%s/taoLti/Security/oidcInitiation' % self.audience,
        },
      },
      scopes: [
        'https://purl.imsglobal.org/spec/lti-nrps/scope/contextmembership.readonly',
        'https://purl.imsglobal.org/spec/lti-bo/scope/basicoutcome',
        'https://purl.imsglobal.org/spec/lti-ap/scope/control.all',
        'https://purl.imsglobal.org/spec/lti-ags/scope/lineitem',
        'https://purl.imsglobal.org/spec/lti-ags/scope/lineitem.readonly',
        'https://purl.imsglobal.org/spec/lti-ags/scope/score',
        'https://purl.imsglobal.org/spec/lti-ags/scope/result.readonly',
      ],
    },
  }
