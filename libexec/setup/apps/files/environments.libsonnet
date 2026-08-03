function(setup)
  {
    environments: [
      {
        configurations: [
          {
            name: 'service_type',
            value: 'ce-tao-deliver-be-service',
          },
          {
            name: 'allowSkipAuthenticate',
            value: 'true',
          },
          {
            name: 'deliver-registration-id',
            value: 'lti-platformless',
          },
          {
            name: 'portal.configuration',
            value: '{"backgroundImage": "assets/image.png","locale": "%(defaultLocale)s" ,"backgroundImageVeil": "red2orange", "corporateText": "For education organizations who want the freedom to control and own their assessment experience, from content to technology to delivery to reporting, the TAO assessment platform delivers maximum flexibility, interoperability, and security.", "corporateTitle": "Accelerating Innovation in Assessment", "defaultCurrency": "EUR", "defaultTimeZone": "Europe/Luxembourg", "linkVisibility": true, "logoImage": "", "productName": "TAO Portal", "selfRegistrationLink": { }, "ssoProviders": [ ], "templates": [ ], "title": "Log in to TAO"}' % setup,
          },
          {
            name: 'portal.backoffice.url',
            value: 'https://%s/backoffice' % [setup.publicDomain],
          },
          {
            name: 'portal.testrunner_client_id',
            value: 'lti-portal-deliver-#tenantId#',
          },
          {
            name: 'portal.proctoring_client_id',
            value: 'lti-portal-proctoring-#tenantId#',
          },
          {
            name: 'scoring-deliver.registration_id',
            value: 'lti-ms-deliver-#tenantId#',
          },
          {
            name: 'portal.grader_client_id',
            value: 'lti-portal-grader-#tenantId#',
          },
          {
            name: 'portal.authoring_client_id',
            value: 'lti-portal-authoring-#tenantId#',
          },
          {
            name: 'portal.csv_results_fields',
            value: '["login",{ "key": "ltiParameters.name", "header": "userName" },"score","maxScore","outcomes.*","sessionStartTime","sessionEndTime","deliveryId",{ "key": "metadata.Label", "header": "deliveryLabel" },"items.*.qtiTitle","items.*.qtiLabel","items.*.statusCorrect","items.*.responses","items.*.duration","items.*.numAttempts","items.*.outcomes", { "key": "ltiParameters.spec_lti_claim_custom_metadata_*", "header": "customMetadata_*" }]',
          },
          {
            name: 'proctoring.registration_id',
            value: 'lti-deliver-proctoring',
          },
          {
            name: 'timers.configuration.thresholds',
            value: '[{"threshold":600000,"refreshRate":30000},{"threshold":1000,"refreshRate":500}]',
          },
          {
            name: 'MSConfiguration',
            value: '{"static_url": "https://%s/ms"}' % [setup.publicDomain],
          },
        ],
        featureFlags: [
          {
            name: 'SCORING_SUBMISSION_ENABLED',
            value: 'true',
          },
          {
            name: 'SCORING_OWNS_GRADING_PROGRESS',
            value: 'true',
          },
          {
            name: 'DATA_STORE_ENABLE_RESULTS_TRANSFER',
            value: 'true',
          },
          {
            name: 'TESTRUNNER_READALOUD_FORCED',
            value: 'true',
          },
          {
            name: 'TIMERS_STOP_ON_DISCONNECT',
            value: 'true',
          },
          {
            name: 'ms.is_item_review_highlighter_enabled',
            value: 'false',
          },
          {
            name: 'FF_ENABLE_RBAC_MODE',
            value: 'true',
          },
          {
            name: 'AUTHORING_SSO_ENABLED',
            value: 'false',
          },
          {
            name: 'mergeUsersEnabled',
            value: 'false',
          },
          {
            name: 'reportGenerationEnabled',
            value: 'false',
          },
          {
            name: 'metadataEnabled',
            value: 'false',
          },
          {
            name: 'userEventsEnabled',
            value: 'false',
          },
          {
            name: 'sessionClustersEnabled',
            value: 'false',
          },
          {
            name: 'enrollmentSessionsEnabled',
            value: 'false',
          },
          {
            name: 'ADD_CUSTOM_TOUCHED_OUTCOME_VARIABLE_TO_RESULT',
            value: 'false',
          },
          {
            name: 'emailNotificationForBulkUserCreateEnabled',
            value: 'false',
          },
          {
            name: 'ms.isMarkAsSuspiciousForCheatingEnabled',
            value: 'false',
          },
          {
            name: 'diplomaGenerationEnabled',
            value: 'false',
          },
          {
            name: 'rbacEnabled',
            value: 'false',
          },
          {
            name: 'acs.feature',
            value: 'true',
          },
          {
            name: 'DIAGNOSTIC_WORKSTATION_ID',
            value: 'true',
          },
          {
            name: 'DIAGNOSTIC_AUDIO_TEST',
            value: 'true',
          },
          {
            name: 'AUTOMATIC_SESSION_SELECTION',
            value: 'false',
          },
          {
            name: 'REDIRECT_TO_LAUNCH_URL',
            value: 'true',
          },
          {
            name: 'FEATURE_FLAG_TEST_NAVIGATION_NONLINEAR_RESTRICTED',
            value: 'false',
          },
          {
            name: 'dashboardEnabled',
            value: 'false',
          },
          {
            name: 'monitoringEnabled',
            value: 'true',
          },
          {
            name: 'MINIMAL_UI_TEST_TAKER',
            value: 'false',
          },
          {
            name: 'gradingEnabled',
            value: 'true',
          },
          {
            name: 'batteryEnabled',
            value: 'false',
          },
          {
            name: 'hierarchyEnabled',
            value: 'true',
          },
          {
            name: 'testsEnabled',
            value: 'false',
          },
          {
            name: 'offlineVmEnabled',
            value: 'false',
          },
          {
            name: 'earlyAdopter',
            value: 'true',
          },
          {
            name: 'emailNotificationEnabled',
            value: 'false',
          },
          {
            name: 'publicSessionsEnabled',
            value: 'false',
          },
          {
            name: 'userLoginGenerationEnabled',
            value: 'false',
          },
          {
            name: 'CERTIFICATION_PRODUCT',
            value: 'false',
          },
          {
            name: 'easyPasswordEnabled',
            value: 'false',
          },
          {
            name: 'enableProctoring',
            value: 'false',
          },
          {
            name: 'supportEnabled',
            value: 'false',
          },
          {
            name: 'WORKING_PROFILES_ENABLED',
            value: 'false',
          },
          {
            name: 'ms.isSuggestedScoringEnabled',
            value: 'false',
          },
          {
            name: 'readBehindEnabled',
            value: 'false',
          },
        ],
        ltiPlatforms: [
          {
            audience: 'https://%s/devkit/platform' % [setup.publicDomain],
            id: 'devkit-platform',
            isInternal: false,
            name: 'DevKit LTI Platform',
            oauth2AccessTokenUrl: '%s/lti1p3/auth/platformKey/token' % setup.apps.devkit.backend.http.url,
            oidcAuthenticationUrl: 'https://%s/devkit/lti1p3/oidc/authentication' % [setup.publicDomain],
          },
          {
            audience: 'https://%s/deliver' % [setup.publicDomain],
            id: 'deliver-platform',
            isInternal: true,
            name: 'Test runner as LTI Platform',
            oauth2AccessTokenUrl: '%s/v1/oauth2/tokens' % setup.apps['environment-management'].auth_server.http.url,
            oidcAuthenticationUrl: 'https://%s/deliver/lti1p3/oidc/authentication' % [setup.publicDomain],
          },
          {
            audience: 'https://%s/backoffice' % [setup.publicDomain],
            id: 'backoffice-platform',
            isInternal: false,
            name: 'Backoffice LTI Platform',
            oauth2AccessTokenUrl: '%s/taoLti/Security/oauth' % [setup.apps.construct.backend.http.url],
            oidcAuthenticationUrl: 'https://%s/backoffice/taoLti/Security/oidc' % [setup.publicDomain],
          },
          {
            audience: 'https://%s/ms-be' % [setup.publicDomain],
            id: 'ms-platform',
            isInternal: true,
            name: 'MS LTI Platform',
            oauth2AccessTokenUrl: '%s/v1/oauth2/tokens' % setup.apps['environment-management'].auth_server.http.url,
            oidcAuthenticationUrl: 'https://%s/ms-be/lti1p3/oidc/authentication' % [setup.publicDomain],
          },
          {
            id: 'portal-platform',
            name: 'Portal LTI platform',
            audience: 'https://%s/portal-be' % [setup.publicDomain],
            oauth2AccessTokenUrl: '%s/v1/oauth2/tokens' % setup.apps['environment-management'].auth_server.http.url,
            oidcAuthenticationUrl: 'http://foo.bar',
            isInternal: true,
          },
        ],
        ltiRegistrations: [
          {
            clientId: 'lti-devkit-deliver-#tenantId#',
            deploymentIds: [
              'deploymentId',
            ],
            id: 'lti-devkit-deliver-#tenantId#',
            platformId: 'devkit-platform',
            platformJwksUrl: '%s/lti1p3/.well-known/jwks/primaryKeySet.json' % setup.apps.devkit.backend.http.url,
            platformKeyChain: {},
            toolId: 'deliver-tool',
            toolJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            toolKeyChain: {},
          },
          {
            clientId: 'lti-deliver-devkit-#tenantId#',
            deploymentIds: [
              '1',
            ],
            id: 'lti-deliver-devkit-#tenantId#',
            platformId: 'deliver-platform',
            platformJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            platformKeyChain: {},
            toolId: 'devkit-tool',
            toolJwksUrl: '%s/lti1p3/.well-known/jwks/primaryKeySet.json' % setup.apps.devkit.backend.http.url,
            toolKeyChain: {},
          },
          {
            clientId: 'lti-devkit-manual-scoring-#tenantId#',
            deploymentIds: [
              '1',
            ],
            id: 'lti-devkit-manual-scoring-#tenantId#',
            platformId: 'devkit-platform',
            platformJwksUrl: '%s/lti1p3/.well-known/jwks/primaryKeySet.json' % setup.apps.devkit.backend.http.url,
            platformKeyChain: {},
            toolId: 'ms-tool',
            toolJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            toolKeyChain: {},
          },
          {
            clientId: 'lti-ms-deliver-#tenantId#',
            deploymentIds: [
              '1',
            ],
            id: 'lti-ms-deliver-#tenantId#',
            platformId: 'ms-platform',
            platformJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            platformKeyChain: {},
            toolId: 'deliver-tool',
            toolJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            toolKeyChain: {},
          },
          {
            clientId: 'lti-devkit-proctoring-#tenantId#',
            deploymentIds: [
              '1',
            ],
            id: 'lti-devkit-proctoring-#tenantId#',
            platformId: 'devkit-platform',
            platformJwksUrl: '%s/lti1p3/.well-known/jwks/primaryKeySet.json' % setup.apps.devkit.backend.http.url,
            platformKeyChain: {},
            toolId: 'proctoring-tool',
            toolJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            toolKeyChain: {},
          },
          {
            clientId: 'lti-portal-proctoring-#tenantId#',
            clientSecret: setup.lib.hash('lti-portal-proctoring'),
            deploymentIds: [
              '1',
            ],
            id: 'lti-portal-proctoring-#tenantId#',
            isInternal: true,
            platformId: 'portal-platform',
            platformJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            platformKeyChain: {},
            toolId: 'proctoring-tool',
            toolJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            toolKeyChain: {},
          },

          {
            clientId: 'lti-portal-deliver-#tenantId#',
            deploymentIds: [
              '1',
            ],
            id: 'lti-portal-deliver-#tenantId#',
            platformId: 'portal-platform',
            platformJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            platformKeyChain: {},
            toolId: 'deliver-tool',
            toolJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            toolKeyChain: {},
          },
          {
            clientId: 'lti-portal-authoring-#tenantId#',
            clientSecret: setup.lib.hash('lti-portal-authoring'),
            deploymentIds: [
              '1',
            ],
            id: 'lti-portal-authoring-#tenantId#',
            isInternal: true,
            platformId: 'portal-platform',
            platformJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            platformKeyChain: {},
            tenantId: '1',
            toolId: 'authoring-tool',
            toolJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            toolKeyChain: {},
          },
          {
            clientId: 'lti-portal-grader-#tenantId#',
            clientSecret: setup.lib.hash('lti-portal-grader'),
            deploymentIds: [
              '1',
            ],
            id: 'lti-portal-grader-#tenantId#',
            isInternal: true,
            platformId: 'portal-platform',
            platformJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            platformKeyChain: {},
            tenantId: '1',
            toolId: 'ms-tool',
            toolJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            toolKeyChain: {},
          },
          {
            id: 'lti-deliver-proctoring',
            clientId: 'lti-deliver-proctoring',
            tenantId: '1',
            clientSecret: setup.lib.hash('lti-deliver-proctoring'),
            platformId: 'portal-platform',
            toolId: 'assessment-proctoring-tool',
            platformJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            toolJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            platformKeyChain: {
            },
            toolKeyChain: {
            },
            deploymentIds: ['1'],
          },
        ],
        ltiRoleMappings: [
          {
            clientId: 'lti-portal-deliver-#tenantId#',
            defaultLtiRole: 'http://purl.imsglobal.org/vocab/lis/v2/membership#Learner',
            map: [
              {
                internalRoles: [
                  'ADMIN',
                  'TEST_TAKER',
                ],
                ltiRole: 'http://purl.imsglobal.org/vocab/lis/v2/membership#Learner',
              },
            ],
          },
          {
            clientId: 'lti-portal-proctoring-#tenantId#',
            map: [
              {
                internalRoles: [
                  'ADMIN',
                ],
                ltiRole: 'http://purl.imsglobal.org/vocab/lis/v2/membership#Instructor',
              },
            ],
          },
          {
            clientId: 'lti-portal-authoring-#tenantId#',
            map: [
              {
                internalRoles: [
                  'ADMIN',
                ],
                ltiRole: 'http://purl.imsglobal.org/vocab/lis/v2/membership/Administrator#Developer',
              },
              {
                internalRoles: [
                  'CONTENT_CREATOR',
                  'ADMIN',
                ],
                ltiRole: 'http://purl.imsglobal.org/vocab/lis/v2/membership/ContentDeveloper#ContentDeveloper',
              },
            ],
          },
          {
            clientId: 'lti-portal-grader-#tenantId#',
            defaultLtiRole: 'http://purl.imsglobal.org/vocab/lis/v2/institution/person#Instructor',
            map: [],
          },
        ],
        ltiTools: [
          {
            audience: 'https://%s/deliver' % [setup.publicDomain],
            deepLinkingUrl: 'https://%s/deliver/api/v1/lti/deep-links' % [setup.publicDomain],
            id: 'deliver-tool',
            isInternal: true,
            launchUrl: 'https://%s/deliver/api/v1/auth/launch-lti-1p3' % [setup.publicDomain],
            name: 'Test runner as LTI Tool',
            oidcInitiationUrl: 'https://%s/auth-server/lti1p3/oidc/initiation' % [setup.publicDomain],
          },
          {
            audience: 'https://%s/devkit/tool' % [setup.publicDomain],
            deepLinkingUrl: '',
            id: 'devkit-tool',
            launchUrl: 'https://%s/devkit/tool/launch' % [setup.publicDomain],
            name: 'DevKit LTI tool',
            oidcInitiationUrl: 'https://%s/devkit/lti1p3/oidc/initiation' % [setup.publicDomain],
          },
          {
            audience: 'https://%s/ms-be' % [setup.publicDomain],
            deepLinkingUrl: '',
            id: 'ms-tool',
            isInternal: true,
            launchUrl: 'https://%s/ms-be/api/v1/lti1p3/launch' % [setup.publicDomain],
            name: 'MS LTI Tool',
            oidcInitiationUrl: 'https://%s/auth-server/lti1p3/oidc/initiation' % [setup.publicDomain],
          },
          {
            id: 'assessment-proctoring-tool',
            name: 'Proctoring tool for Deliver BE',
            audience: 'https://%s/pr-lti-gateway' % [setup.publicDomain],
            oidcInitiationUrl: 'https://%s/auth-server/lti1p3/oidc/initiation' % [setup.publicDomain],
            launchUrl: 'https://%s/pr-lti-gateway/api/v1/actions/proctoring/start' % [setup.publicDomain],
            deepLinkingUrl: '',
            isInternal: true,
          },
          {
            id: 'proctoring-tool',
            name: 'Proctoring tool',
            audience: 'https://%s/pr-lti-gateway' % [setup.publicDomain],
            oidcInitiationUrl: 'https://%s/auth-server/lti1p3/oidc/initiation' % [setup.publicDomain],
            launchUrl: 'https://%s/pr-lti-gateway/api/v1/lti1p3/launch' % [setup.publicDomain],
            deepLinkingUrl: '',
            isInternal: true,
          },
          {
            audience: 'https://%s/backoffice' % [setup.publicDomain],
            deepLinkingUrl: '',
            id: 'authoring-tool',
            isInternal: true,
            launchUrl: 'https://%s/backoffice/taoLti/AuthoringTool/launch' % [setup.publicDomain],
            name: 'Authoring tool',
            oidcInitiationUrl: 'https://%s/auth-server/lti1p3/oidc/initiation' % [setup.publicDomain],
          },
        ],
        meta: {
          id: 'community-tao-environment',
          name: 'Community TAO Environment',
        },
        oauth2Clients: [
          {
            clientId: 'admin',
            clientSecret: setup.lib.hash('admin'),
            isConfidential: false,
            name: 'Portal Backend OAuth2 Client',
            scopes: [
              'admin',
              'tenant-api:full-access',
            ],
          },
          {
            clientId: 'lti-portal-proctoring-#tenantId#',
            clientSecret: setup.lib.hash('lti-portal-proctoring'),
            isConfidential: true,
            name: 'Proctoring OAuth2 Credentials',
            scopes: [
              'https://purl.imsglobal.org/spec/lti-ap/scope/control.all',
            ],
          },
          {
            clientId: 'admin-#tenantId#',
            clientSecret: setup.lib.hash('admin'),
            isConfidential: false,
            name: 'Portal Backend OAuth2 Client per tenant',
            scopes: [
              'admin',
            ],
          },
          {
            clientId: 'lti-devkit-deliver-#tenantId#',
            clientSecret: setup.lib.hash('lti-devkit-deliver'),
            isConfidential: true,
            name: 'Publication OAuth2 Credentials',
            scopes: [
              'results:post',
            ],
          },
          {
            clientId: 'lti-deliver-devkit-#tenantId#',
            clientSecret: setup.lib.hash('lti-deliver-devkit'),
            isConfidential: true,
            name: 'Proctoring OAuth2 Credentials',
            scopes: [
              'https://purl.imsglobal.org/spec/lti-ap/scope/control.all',
            ],
          },
          {
            clientId: 'lti-devkit-manual-scoring-#tenantId#',
            clientSecret: setup.lib.hash('lti-devkit-manual-scoring'),
            isConfidential: false,
            name: 'Manual Scoring OAuth2 Client',
            scopes: [],
          },
          {
            clientId: 'lti-portal-deliver-#tenantId#',
            clientSecret: setup.lib.hash('lti-portal-deliver-#tenantId#'),
            isConfidential: false,
            name: 'Portal Backend OAuth2 Client',
            scopes: [
              'launch_delivery_execution',
            ],
          },
        ],
        userRoles: [
          {
            global: false,
            name: 'DATA_EXPLORER',
            permissions: [
              {
                resource: 'portal.results',
                scopes: [
                  'view',
                ],
              },
              {
                resource: 'portal.explorer',
                scopes: [
                  'view',
                ],
              },
            ],
          },
          {
            global: false,
            name: 'DATA_EXPLORER_PORTAL_ENTITY',
            permissions: [
              {
                resource: 'portal.explorer-entity',
                scopes: [
                  'edit',
                  'view',
                ],
              },
              {
                resource: 'portal.results',
                scopes: [
                  'view',
                ],
              },
              {
                resource: 'portal.explorer',
                scopes: [
                  'view',
                ],
              },
            ],
          },
          {
            global: false,
            name: 'DATA_EXPLORER_LOG',
            permissions: [
              {
                resource: 'portal.explorer-log',
                scopes: [
                  'edit',
                  'view',
                ],
              },
              {
                resource: 'portal.results',
                scopes: [
                  'view',
                ],
              },
              {
                resource: 'portal.explorer',
                scopes: [
                  'view',
                ],
              },
            ],
          },
          {
            global: false,
            name: 'DATA_EXPLORER_VIEW_MANAGER',
            permissions: [
              {
                resource: 'portal.explorer-view',
                scopes: [
                  'create',
                ],
              },
              {
                resource: 'portal.results',
                scopes: [
                  'view',
                ],
              },
              {
                resource: 'portal.explorer',
                scopes: [
                  'view',
                ],
              },
            ],
          },
          {
            global: false,
            name: 'DATA_EXPLORER_DATA_EXPORTER',
            permissions: [
              {
                resource: 'portal.explorer-data',
                scopes: [
                  'create',
                ],
              },
              {
                resource: 'portal.results',
                scopes: [
                  'view',
                ],
              },
              {
                resource: 'portal.explorer',
                scopes: [
                  'view',
                ],
              },
            ],
          },
          {
            global: true,
            name: 'ADMIN',
            permissions: [
              {
                resource: 'any',
                scopes: [
                  'all',
                ],
              },
            ],
            restrictions: [
              {
                resource: 'portal.my-session',
                scopes: [
                  'view',
                ],
              },
              {
                resource: 'portal.battery',
                scopes: [
                  'list',
                  'view',
                  'all',
                ],
              },
              {
                resource: 'portal.tests',
                scopes: [],
              },
              {
                resource: 'portal.system-settings',
                scopes: [
                  'create',
                  'view',
                  'edit',
                  'delete',
                ],
              },
              {
                resource: 'portal.experimental-features',
                scopes: [
                  'view',
                ],
              },
              {
                resource: 'portal.labs',
                scopes: [
                  'view',
                  'all',
                ],
              },
              {
                resource: 'portal.organization',
                scopes: [
                  'create',
                  'edit',
                  'view',
                  'all',
                ],
              },
            ],
          },
          {
            global: true,
            name: 'CONTENT_CREATOR',
            permissions: [
              {
                resource: 'portal.content-bank',
                scopes: [
                  'view',
                ],
              },
              {
                resource: 'portal.delivery',
                scopes: ['create', 'view', 'edit', 'delete', 'list'],
              },
            ],
            restrictions: [
              {
                resource: 'portal.battery',
                scopes: [
                  'list',
                  'view',
                  'all',
                ],
              },
              {
                resource: 'portal.labs',
                scopes: [
                  'view',
                  'all',
                ],
              },
            ],
          },
          {
            global: true,
            name: 'DASHBOARD_VIEWER',
            permissions: [
              {
                resource: 'portal.dashboard',
                scopes: [
                  'view',
                ],
              },
            ],
            restrictions: [
              {
                resource: 'portal.battery',
                scopes: [
                  'list',
                  'view',
                  'all',
                ],
              },
              {
                resource: 'portal.labs',
                scopes: [
                  'view',
                  'all',
                ],
              },
            ],
          },
          {
            global: true,
            name: 'GROUP_CREATOR',
            permissions: [
              {
                resource: 'portal.group',
                scopes: [
                  'view',
                  'create',
                ],
              },
            ],
          },
          {
            global: false,
            name: 'GROUP_MANAGER',
            permissions: [
              {
                resource: 'portal.group',
                scopes: [
                  'view',
                  'edit',
                  'delete',
                ],
              },
              {
                resource: 'portal.session',
                scopes: [
                  'create',
                  'view',
                  'edit',
                  'delete',
                  'grade',
                  'review-grade',
                  'reopen-grade',
                  'preview',
                ],
              },
              {
                resource: 'portal.review-session',
                scopes: [
                  'view',
                  'edit',
                ],
              },
              {
                resource: 'portal.csv-export',
                scopes: [
                  'view',
                ],
              },
              {
                resource: 'portal.delivery',
                scopes: [
                  'view',
                  'list',
                ],
              },
              {
                resource: 'portal.battery',
                scopes: [
                  'list',
                ],
              },
            ],
            restrictions: [
              {
                resource: 'portal.battery',
                scopes: [
                  'list',
                  'view',
                  'all',
                ],
              },
              {
                resource: 'portal.labs',
                scopes: [
                  'view',
                  'all',
                ],
              },
            ],
          },
          {
            global: false,
            name: 'GRADER',
            permissions: [
              {
                resource: 'portal.session',
                scopes: [
                  'view',
                  'grade',
                  'preview',
                ],
              },
            ],
            restrictions: [
              {
                resource: 'portal.battery',
                scopes: [
                  'list',
                  'view',
                  'all',
                ],
              },
              {
                resource: 'portal.labs',
                scopes: [
                  'view',
                  'all',
                ],
              },
            ],
          },
          {
            global: false,
            name: 'TEST_TAKER',
            permissions: [
              {
                resource: 'portal.my-session',
                scopes: [
                  'view',
                  'review',
                ],
              },
              {
                resource: 'portal.review-session',
                scopes: [
                  'view',
                  'edit',
                ],
              },
              {
                resource: 'portal.payment',
                scopes: [
                  'create',
                ],
              },
            ],
            restrictions: [
              {
                resource: 'portal.battery',
                scopes: [
                  'list',
                  'view',
                  'all',
                ],
              },
              {
                resource: 'portal.labs',
                scopes: [
                  'view',
                  'all',
                ],
              },
            ],
          },
          {
            global: false,
            name: 'REVIEW_GRADER',
            permissions: [
              {
                resource: 'portal.session',
                scopes: [
                  'view',
                  'review-grade',
                  'preview',
                ],
              },
            ],
            restrictions: [
              {
                resource: 'portal.battery',
                scopes: [
                  'list',
                  'view',
                  'all',
                ],
              },
              {
                resource: 'portal.labs',
                scopes: [
                  'view',
                  'all',
                ],
              },
            ],
          },
          {
            global: true,
            name: 'PUBLIC_SESSION_MANAGER',
            permissions: [
              {
                resource: 'portal.public-session',
                scopes: [
                  'create',
                  'view',
                  'edit',
                  'delete',
                ],
              },
              {
                resource: 'portal.delivery',
                scopes: [
                  'list',
                ],
              },
              {
                resource: 'portal.battery',
                scopes: [
                  'list',
                ],
              },
            ],
            restrictions: [
              {
                resource: 'portal.battery',
                scopes: [
                  'list',
                  'view',
                  'all',
                ],
              },
              {
                resource: 'portal.labs',
                scopes: [
                  'view',
                  'all',
                ],
              },
            ],
          },
          {
            global: true,
            name: 'SYSTEM_MANAGER',
            permissions: [
              {
                resource: 'portal.system-settings',
                scopes: [
                  'edit',
                ],
              },
            ],
            restrictions: [
              {
                resource: 'portal.battery',
                scopes: [
                  'list',
                  'view',
                  'all',
                ],
              },
              {
                resource: 'portal.labs',
                scopes: [
                  'view',
                  'all',
                ],
              },
            ],
          },
          {
            global: false,
            name: 'WORKING_PROFILES_MANAGER',
            permissions: [
              {
                resource: 'portal.user.working-profiles',
                scopes: [
                  'all',
                ],
              },
            ],
            restrictions: [
              {
                resource: 'portal.battery',
                scopes: [
                  'list',
                  'view',
                  'all',
                ],
              },
              {
                resource: 'portal.labs',
                scopes: [
                  'view',
                  'all',
                ],
              },
            ],
          },
        ],
      },
    ],
  }
