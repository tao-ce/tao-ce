function(setup)
  std.parseYaml(importstr './lti1p3.yaml')
  + {
    lti1p3+: {
      platforms+: {
        deliverPlatform+: {
          audience: 'https://' + setup.publicDomain + '/deliver',
          oauth2_access_token_url: '%s/lti1p3/auth/primaryKeyPair/token' % setup.apps['environment-management'].auth_server.http.url,
          oidc_authentication_url: 'https://%s/deliver/lti1p3/oidc/authentication' % setup.publicDomain,

        },
        devkitPlatform+: {
          audience: 'https://' + setup.publicDomain + '/devkit/platform',
          oauth2_access_token_url: '%s/lti1p3/auth/primaryKeyPair/token' % setup.apps.devkit.backend.http.url,
          oidc_authentication_url: 'https://%s/devkit/lti1p3/oidc/authentication' % setup.publicDomain,

        },
      },
      registrations+: {
        'deliver--devkit'+: {
          platform_jwks_url: '%s/lti1p3/.well-known/jwks/primaryKeySet.json' % setup.apps.devkit.backend.http.url,
          tool_jwks_url: '%s/lti1p3/.well-known/jwks/primaryKeySet.json' % setup.apps['environment-management'].auth_server.http.url,

        },
        'devkit--backoffice'+: {
          platform_jwks_url: '%s/lti1p3/.well-known/jwks/primaryKeySet.json' % setup.apps.devkit.backend.http.url,
          tool_jwks_url: '%s/taoLti/Security/jwks' % setup.apps.construct.backend.http.url,
        },
        'devkit--deliver'+: {
          platform_jwks_url: '%s/lti1p3/.well-known/jwks/primaryKeySet.json' % setup.apps.devkit.backend.http.url,
          tool_jwks_url: '%s/lti1p3/.well-known/jwks/primaryKeySet.json' % setup.apps['environment-management'].auth_server.http.url,
        },
        'devkit--devkit'+: {
          platform_jwks_url: '%s/lti1p3/.well-known/jwks/primaryKeySet.json' % setup.apps.devkit.backend.http.url,
          tool_jwks_url: self.platform_jwks_url,
        },
        //TODO
        // "devkit--ms"
        // "devkit--proctoring"
      },
      tools+: {
        local oidc_url = 'https://%s/auth-server/lti1p3/oidc/initiation' % setup.publicDomain,
        deliverTool+: {
          audience: 'https://%s/deliver' % setup.publicDomain,
          deep_linking_url: '%s/api/v1/lti/deep-links' % self.audience,
          launch_url: '%s/api/v1/auth/launch-lti-1p3/' % self.audience,
          oidc_initiation_url: oidc_url,
        },
        devkitTool+: {
          audience: 'https://%s/devkit/tool' % setup.publicDomain,
          launch_url: '%s/launch' % self.audience,
          deep_linking_url: self.launch_url,
          oidc_initiation_url: 'https://%s/devkit/lti1p3/oidc/initiation' % setup.publicDomain,
        },
        manualScoringTool+: {
          audience: 'https://%s/ms-be' % setup.publicDomain,
          deep_linking_url: '~',
          launch_url: '%s/api/v1/lti1p3/launch' % self.audience,
          oidc_initiation_url: oidc_url,
        },
        proctoringTool+: {
          audience: 'https://%s/pr-lti-gateway' % setup.publicDomain,
          deep_linking_url: '~',
          launch_url: '%s/api/v1/lti1p3/launch' % self.audience,
          oidc_initiation_url: oidc_url,
        },
        taoBackofficeTool+: {
          audience: 'https://%s/backoffice' % setup.publicDomain,
          deep_linking_url: '~',
          launch_url: '%s/ltiDeliveryProvider/DeliveryTool/launch1p3?delivery=' % self.audience,
          oidc_initiation_url: '%s/taoLti/Security/oidcInitiation' % self.audience,
        },
      },
    },
  }
