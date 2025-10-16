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
            name: 'example-config-1',
            value: '1',
          },
          {
            name: 'allowSkipAuthenticate',
            value: 'true',
          },
          {
            name: 'deliver-registration-id',
            value: 'portal--deliver-#tenantId#',
          },
          {
            name: 'synchronizer-registration-id',
            value: 'synchronizer-client-id-#tenantId#',
          },
          {
            name: 'portal.configuration',
            value: '{"backgroundImage": "assets/image.png", "backgroundImageVeil": "red2orange", "corporateText": "For education organizations who want the freedom to control and own their assessment experience, from content to technology to delivery to reporting, the TAO assessment platform delivers maximum flexibility, interoperability, and security.", "corporateTitle": "Accelerating Innovation in Assessment", "defaultCurrency": "EUR", "defaultTimeZone": "Europe/Luxembourg", "linkVisibility": true, "logoImage": "", "productName": "TAO Portal", "selfRegistrationLink": { }, "ssoProviders": [ ], "templates": [ ], "title": "Log in to TAO"}',
          },
          {
            name: 'self-registration.configuration',
            value: '{"backgroundImage": "assets/image.png", "backgroundImageVeil": "red2orange", "corporateText": "For education organizations who want the freedom to control and own their assessment experience, from content to technology to delivery to reporting, the TAO assessment platform delivers maximum flexibility, interoperability, and security.", "corporateTitle": "Accelerating Innovation in Assessment", "defaultCurrency": "EUR", "defaultTimeZone": "Europe/Luxembourg", "linkVisibility": true, "logoImage": "", "productName": "TAO Portal", "selfRegistrationLink": { }, "ssoProviders": [ ], "templates": [ ], "title": "Log in to TAO"}',
          },
          {
            name: 'portal.backoffice.url',
            value: 'https://%s/backoffice' % [setup.publicDomain],
          },
          {
            name: 'portal.testrunner_client_id',
            value: 'portal-deliver-client-id-#tenantId#',
          },
          {
            name: 'portal.proctoring_client_id',
            value: 'portal-proctoring-client-id-#tenantId#',
          },
          {
            name: 'scoring-deliver.registration_id',
            value: 'ms--deliver-#tenantId#',
          },
          {
            name: 'portal.grader_client_id',
            value: 'portal-grader-client-id-#tenantId#',
          },
          {
            name: 'portal.authoring_client_id',
            value: 'portal-authoring-client-id-#tenantId#',
          },
          {
            name: 'portal.csv_results_fields',
            value: '["login",{ "key": "ltiParameters.name", "header": "userName" },"score","maxScore","outcomes.*","sessionStartTime","sessionEndTime","deliveryId",{ "key": "metadata.Label", "header": "deliveryLabel" },"items.*.qtiTitle","items.*.qtiLabel","items.*.statusCorrect","items.*.responses","items.*.duration","items.*.numAttempts","items.*.outcomes", { "key": "ltiParameters.spec_lti_claim_custom_metadata_*", "header": "customMetadata_*" }]',
          },
          {
            name: 'proctoring.registration_id',
            value: 'deliver--proctoring',
          },
          {
            name: 'proctoring.external_providers',
            value: '[{"clientId": "deliver-be-devkit-#tenantId#", "launchClaims": {"https://purl.imsglobal.org/spec/lti/claim/roles": ["http://purl.imsglobal.org/vocab/lis/v2/membership#Administrator"]}, "providerName": "devkit"}, {"clientId": "proctorio_oat-staging-eu_oat-bench_#tenantId#", "launchClaims": {"https://purl.imsglobal.org/spec/lti/claim/roles": ["http://purl.imsglobal.org/vocab/lis/v2/membership#Reviewer"]}, "providerName": "proctorio", "settings": {"exam_settings": {"block_downloads": false, "calculator": 1, "close_tabs": true, "disable_clipboard": false, "disable_right_click": false, "full_screen": 3, "one_screen": true, "record_audio": true, "record_desk": 2, "record_video": true, "tabs": 1, "verify_audio": true, "verify_signature": false, "verify_video": true, "whiteboard": true}}}]',
          },
          {
            name: 'portal.test_categories',
            value: [],
          },
          {
            name: 'timers.configuration.thresholds',
            value: '[{"threshold":600000,"refreshRate":30000},{"threshold":1000,"refreshRate":500}]',
          },
          {
            name: 'MSConfiguration',
            value: '{"static_url": "https://%s/ms"}' % [setup.publicDomain],
          },
          {
            name: 'portal.sessionUserManagement',
            value: {
              userMergeSearch: {
                activityLogEnabled: false,
                filter: [],
                resultMatchCriteria: 'exactMatch',
                userSearchableFields: [
                  'login',
                ],
              },
            },
          },
          {
            name: 'testRunnerConfiguration',
            value: {
              options: {
                itemRunnerConfig: {
                  elements: {
                    CustomInteraction_audioRecordingInteraction: {
                      propertyOverride: {
                        useUploader: true,
                      },
                    },
                    ExtendedTextInteraction: {
                      propertyOverride: {
                        dataAttrs: {
                          'data-image-upload': 'true',
                          'data-word-count': 'true',
                        },
                        uploadMaxSize: 15000000,
                        uploadTimeout: 60000,
                        usePersistentUndoRedo: true,
                      },
                    },
                    UploadInteraction: {
                      propertyOverride: {
                        maxSize: 20000000,
                      },
                    },
                  },
                  options: {
                    hideTooltips: false,
                    stylePromptAsHeader: false,
                  },
                },
                liteMode: false,
                locale: 'en-US',
                plugins: {
                  highlighter: {
                    colors: [
                      'yellow',
                      'blue',
                      'pink',
                      'green',
                      'orange',
                    ],
                  },
                  localItemState: {
                    saveState: {
                      enabled: true,
                      excludePciTypeIdentifiers: [
                        'audioRecordingInteraction',
                      ],
                      liveSaveIndicator: {
                        enabled: true,
                      },
                      maxWait: 20000,
                      minWait: 5000,
                    },
                  },
                  pauseOnBlur: {
                    threshold: 0,
                  },
                  preloadNextItemAssets: {
                    preloadStrategy: {
                      audios: true,
                      audiosThreshold: 3000000,
                      images: true,
                      stylesheets: true,
                      videos: true,
                      videosThreshold: 3000000,
                    },
                  },
                  readAloud: {
                    providerConfig: {},
                    providerId: 'native',
                  },
                },
                proxy: {
                  preloadItemStoreCapacity: 30,
                  preloadSectionItemsAmount: 5,
                  preloadStrategy: 'sectionItems',
                },
              },
              providers: {
                itemRunner: {
                  category: 'runner',
                  id: 'qtinui',
                  module: 'taoQtiNuiItem/runner/qti',
                },
                plugins: [
                  {
                    category: 'content',
                    id: 'titlePlugin',
                    module: 'taoQtiNuiTest/runner/plugins/content/title/plugin',
                  },
                  {
                    category: 'content',
                    id: 'menuPanelPlugin',
                    module: 'taoQtiNuiTest/runner/plugins/panel/menu/plugin',
                  },
                  {
                    category: 'content',
                    id: 'jumpMenuPlugin',
                    module: 'taoQtiNuiTest/runner/plugins/navigation/jumpMenu/plugin',
                  },
                  {
                    category: 'content',
                    id: 'navigatorPlugin',
                    module: 'taoQtiNuiTest/runner/plugins/navigation/navigator/plugin',
                  },
                  {
                    category: 'state',
                    id: 'localItemState',
                    module: 'taoQtiNuiTest/runner/plugins/localItemState/plugin',
                  },
                  {
                    category: 'performance',
                    id: 'preloadNextItemAssetsPlugin',
                    module: 'taoQtiNuiTest/runner/plugins/navigation/preload/nextItemAssets/plugin',
                  },
                  {
                    category: 'security',
                    id: 'preventDropToInput',
                    module: 'taoQtiNuiTest/runner/plugins/tools/preventDropToInput/plugin',
                  },
                  {
                    category: 'tools',
                    id: 'calculator',
                    module: 'taoQtiNuiTest/runner/plugins/tools/calculator/plugin',
                  },
                  {
                    category: 'tools',
                    id: 'highlighter',
                    module: 'taoQtiNuiTest/runner/plugins/tools/highlighter/plugin',
                  },
                  {
                    category: 'tools',
                    id: 'scratchpad',
                    module: 'taoQtiNuiTest/runner/plugins/tools/scratchpad/plugin',
                  },
                  {
                    category: 'tools',
                    id: 'lineReader',
                    module: 'taoQtiNuiTest/runner/plugins/tools/lineReader/plugin',
                  },
                  {
                    category: 'tools',
                    id: 'readAloud',
                    module: 'taoQtiNuiTest/runner/plugins/tools/readAloud/plugin',
                  },
                  {
                    category: 'tools',
                    id: 'fullscreen',
                    module: 'taoQtiNuiTest/runner/plugins/tools/fullscreen/plugin',
                  },
                  {
                    category: 'tools',
                    id: 'print',
                    module: 'taoQtiNuiTest/runner/plugins/tools/print/plugin',
                  },
                  {
                    category: 'navigation',
                    id: 'warnBeforeLeaving',
                    module: 'taoQtiNuiTest/runner/plugins/navigation/warnBeforeLeaving/plugin',
                  },
                  {
                    category: 'navigation',
                    id: 'proctoring',
                    module: 'taoQtiNuiTest/runner/plugins/proctoring/plugin',
                  },
                  {
                    category: 'navigation',
                    id: 'pciNavigationHelper',
                    module: 'taoQtiNuiTest/runner/plugins/navigation/PCINavigationHelper/plugin',
                  },
                  {
                    category: 'content',
                    id: 'attachments',
                    module: 'taoQtiNuiTest/runner/plugins/content/attachments/plugin',
                  },
                ],
                proxy: {
                  category: 'proxy',
                  id: 'preload-actions-proxy',
                  module: 'taoQtiNuiTest/runner/proxy/preloadProxy',
                },
                runner: {
                  category: 'runner',
                  id: 'qtinui',
                  module: 'taoQtiNuiTest/runner/qti',
                },
              },
              reviewProviders: {
                itemRunner: {
                  category: 'runner',
                  id: 'qtinui',
                  module: 'taoQtiNuiItem/runner/qti',
                },
                plugins: [
                  {
                    category: 'content',
                    id: 'titlePlugin',
                    module: 'taoQtiNuiTest/runner/plugins/content/title/plugin',
                  },
                  {
                    category: 'content',
                    id: 'menuPanelPlugin',
                    module: 'taoQtiNuiTest/runner/plugins/panel/menu/plugin',
                  },
                  {
                    category: 'content',
                    id: 'navigatorPlugin',
                    module: 'taoQtiNuiTest/runner/plugins/navigation/reviewNavigator/plugin',
                  },
                  {
                    category: 'integration',
                    id: 'notify',
                    module: 'taoQtiNuiTest/runner/plugins/integration/notify/plugin',
                  },
                  {
                    category: 'content',
                    id: 'jumpMenuPlugin',
                    module: 'taoQtiNuiTest/runner/plugins/navigation/jumpMenu/plugin',
                  },
                  {
                    category: 'tools',
                    id: 'inlineCommentsPlugin',
                    module: 'taoQtiNuiTest/runner/plugins/tools/inlineComments/plugin',
                  },
                  {
                    category: 'tools',
                    id: 'highlighter',
                    module: 'taoQtiNuiTest/runner/plugins/tools/highlighter/plugin',
                  },
                ],
                proxy: {
                  category: 'proxy',
                  id: 'actions-proxy',
                  module: 'taoQtiNuiTest/runner/proxy/reviewProxy',
                },
                runner: {
                  category: 'runner',
                  id: 'qtinui',
                  module: 'taoQtiNuiTest/runner/qtiReview',
                },
              },
            },
          },
          {
            name: 'portal.sessionCandidateManagement',
            value: '{"candidateIdentifiersStrategy": {"priority": ["metadata.user.ssn", "metadata.user.duf", "metadata.user.dnumber", "metadata.user.passport", "login"]}, "candidateSearch": {"activityLogEnabled": false, "filter": [{"field": "role", "type": "terms", "values": ["TEST_TAKER"]}], "resultMatchCriteria": "exactMatch", "userSearchableFields": ["metadata.ssn", "metadata.duf", "metadata.dnumber", "metadata.passport", "login"]}}',
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
            value: 'false',
          },
          {
            name: 'MINIMAL_UI_TEST_TAKER',
            value: 'false',
          },
          {
            name: 'gradingEnabled',
            value: 'false',
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
            value: 'true',
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
          }
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
            id: 'nextgen-tao-deliver-be-platform',
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
            audience: 'https://%s/portal-be' % [setup.publicDomain],
            id: 'portal-platform',
            isInternal: true,
            name: 'Portal LTI platform',
            oauth2AccessTokenUrl: 'http://foo.bar',
            oidcAuthenticationUrl: 'http://foo.bar',
          },
        ],
        ltiRegistrations: [
          {
            clientId: 'devkit-deliver-be-#tenantId#',
            deploymentIds: [
              'deploymentId',
            ],
            id: 'devkit--deliver-#tenantId#',
            platformId: 'devkit-platform',
            platformJwksUrl: '%s/lti1p3/.well-known/jwks/primaryKeySet.json' % setup.apps.devkit.backend.http.url,
            platformKeyChain: {},
            toolId: 'nextgen-tao-deliver-be-tool',
            toolJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            toolKeyChain: {},
          },
          {
            clientId: 'deliver-be-devkit-#tenantId#',
            deploymentIds: [
              '1',
            ],
            id: 'deliver--devkit-#tenantId#',
            platformId: 'nextgen-tao-deliver-be-platform',
            platformJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            platformKeyChain: {},
            toolId: 'devkit-tool',
            toolJwksUrl: '%s/lti1p3/.well-known/jwks/primaryKeySet.json' % setup.apps.devkit.backend.http.url,
            toolKeyChain: {},
          },
          {
            clientId: 'devkit-manual-scoring-#tenantId#',
            deploymentIds: [
              '1',
            ],
            id: 'devkit--ms-#tenantId#',
            platformId: 'devkit-platform',
            platformJwksUrl: '%s/lti1p3/.well-known/jwks/primaryKeySet.json' % setup.apps.devkit.backend.http.url,
            platformKeyChain: {},
            toolId: 'ms-tool',
            toolJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            toolKeyChain: {},
          },
          {
            clientId: 'manual_scoring_deliver-#tenantId#',
            deploymentIds: [
              '1',
            ],
            id: 'ms--deliver-#tenantId#',
            platformId: 'ms-platform',
            platformJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            platformKeyChain: {},
            toolId: 'nextgen-tao-deliver-be-tool',
            toolJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            toolKeyChain: {},
          },
          {
            clientId: 'proctoring_client_id-#tenantId#',
            deploymentIds: [
              '1',
            ],
            id: 'devkit--proctoring-#tenantId#',
            platformId: 'devkit-platform',
            platformJwksUrl: '%s/lti1p3/.well-known/jwks/primaryKeySet.json' % setup.apps.devkit.backend.http.url,
            platformKeyChain: {},
            toolId: 'proctoring-tool',
            toolJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            toolKeyChain: {},
          },
          {
            clientId: 'portal-proctoring-client-id-#tenantId#',
            clientSecret: 'secret1',
            deploymentIds: [
              '1',
            ],
            id: 'portal--proctoring-#tenantId#',
            isInternal: true,
            platformId: 'portal-platform',
            platformJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            platformKeyChain: {},
            toolId: 'proctoring-tool',
            toolJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            toolKeyChain: {},
          },
          {
            clientId: 'portal-deliver-client-id-#tenantId#',
            deploymentIds: [
              '1',
            ],
            id: 'portal--deliver-#tenantId#',
            platformId: 'portal-platform',
            platformJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            platformKeyChain: {},
            toolId: 'nextgen-tao-deliver-be-tool',
            toolJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            toolKeyChain: {},
          },
          {
            clientId: 'portal-authoring-client-id-#tenantId#',
            clientSecret: 'secret1',
            deploymentIds: [
              '1',
            ],
            id: 'portal--authoring-#tenantId#',
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
            clientId: 'portal-grader-client-id-#tenantId#',
            clientSecret: 'secret1',
            deploymentIds: [
              '1',
            ],
            id: 'portal--grader-#tenantId#',
            isInternal: true,
            platformId: 'portal-platform',
            platformJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            platformKeyChain: {},
            tenantId: '1',
            toolId: 'ms-tool',
            toolJwksUrl: '%s/.well-known/jwks.json' % setup.apps['environment-management'].auth_server.http.url,
            toolKeyChain: {},
          },
        ],
        ltiRoleMappings: [
          {
            clientId: 'portal-deliver-client-id-#tenantId#',
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
            clientId: 'portal-proctoring-client-id-#tenantId#',
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
            clientId: 'portal-authoring-client-id-#tenantId#',
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
            clientId: 'portal-grader-client-id-#tenantId#',
            defaultLtiRole: 'http://purl.imsglobal.org/vocab/lis/v2/institution/person#Instructor',
            map: [],
          },
        ],
        ltiTools: [
          {
            audience: 'https://%s/deliver' % [setup.publicDomain],
            deepLinkingUrl: 'https://%s/deliver/api/v1/lti/deep-links' % [setup.publicDomain],
            id: 'nextgen-tao-deliver-be-tool',
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
            audience: 'https://%s/pr-lti-gateway' % [setup.publicDomain],
            deepLinkingUrl: '',
            id: 'proctoring-tool',
            isInternal: true,
            launchUrl: 'https://%s/pr-lti-gateway/api/v1/actions/proctoring/start' % [setup.publicDomain],
            name: 'Proctoring tool',
            oidcInitiationUrl: 'https://%s/auth-server/lti1p3/oidc/initiation' % [setup.publicDomain],
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
          id: 'oat-bench-env',
          name: 'OAT BENCH Environment',
        },
        oauth2Clients: [
          {
            clientId: 'launch-client-#tenantId#',
            clientSecret: 'client-secret',
            isConfidential: true,
            name: 'Platform less launch battery',
            scopes: [
              'launch_delivery_execution',
            ],
          },
          {
            clientId: 'admin',
            clientSecret: 'secret',
            isConfidential: false,
            name: 'Portal Backend OAuth2 Client',
            scopes: [
              'admin',
              'tenant-api:full-access',
            ],
          },
          {
            clientId: 'admin-#tenantId#',
            clientSecret: 'secret',
            isConfidential: false,
            name: 'Portal Backend OAuth2 Client per tenant',
            scopes: [
              'admin',
            ],
          },
          {
            clientId: 'devkit-deliver-be-#tenantId#',
            clientSecret: 'client-secret',
            isConfidential: true,
            name: 'Publication OAuth2 Credentials',
            scopes: [
              'results:post',
            ],
          },
          {
            clientId: 'deliver-be-devkit-#tenantId#',
            clientSecret: 'client-secret',
            isConfidential: true,
            name: 'Proctoring OAuth2 Credentials',
            scopes: [
              'https://purl.imsglobal.org/spec/lti-ap/scope/control.all',
            ],
          },
          {
            clientId: 'devkit-manual-scoring-#tenantId#',
            clientSecret: 'secret1',
            isConfidential: false,
            name: 'Manual Scoring OAuth2 Client',
            scopes: [],
          },
          {
            clientId: 'proctoring_client_id-#tenantId#',
            clientSecret: 'secret',
            isConfidential: true,
            name: 'Proctoring OAuth2 Credentials',
            scopes: [
              'https://purl.imsglobal.org/spec/lti-ap/scope/control.all',
            ],
          },
          {
            clientId: 'portal-deliver-client-id-#tenantId#',
            clientSecret: 'secret1',
            isConfidential: false,
            name: 'Portal Backend OAuth2 Client',
            scopes: [
              'launch_delivery_execution',
            ],
          },
          {
            clientId: 'synchronizer-client-id-#tenantId#',
            isConfidential: false,
            name: 'Synchronizer OAuth2 Client',
            scopes: [
              'bucket:admin',
              'dynamic-access:*',
            ],
            users: [],
            usersSource: 'PORTAL',
          },
          {
            clientId: 'internal-sync-user',
            clientSecret: 'internal-sync-user-secret',
            isConfidential: false,
            name: 'Internal Synchronizer OAuth2 Client',
            scopes: [
              'bucket:admin',
            ],
            users: [],
            usersSource: 'PORTAL',
          },
          {
            clientId: 'payment-webhook-client-#tenantId#',
            clientSecret: 'payment-webhook-secret',
            isConfidential: false,
            name: 'Payment Webhook OAuth2 Client',
            scopes: [],
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
          },
        ],
      },
    ],
  }
