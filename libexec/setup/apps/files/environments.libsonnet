function(setup)
{
  "environments": [
    {
      "configurations": [
        {
          "name": "example-config-1",
          "value": "1"
        },
        {
          "name": "allowSkipAuthenticate",
          "value": "true"
        },
        {
          "name": "deliver-registration-id",
          "value": "portal--deliver-#tenantId#"
        },
        {
          "name": "synchronizer-registration-id",
          "value": "synchronizer-client-id-#tenantId#"
        },
        {
          "name": "portal.configuration",
          "value": "{\"backgroundImage\": \"assets/image.png\", \"backgroundImageVeil\": \"red2orange\", \"corporateText\": \"For education organizations who want the freedom to control and own their assessment experience, from content to technology to delivery to reporting, the TAO assessment platform delivers maximum flexibility, interoperability, and security.\", \"corporateTitle\": \"Accelerating Innovation in Assessment\", \"defaultCurrency\": \"EUR\", \"defaultTimeZone\": \"Europe/Luxembourg\", \"linkVisibility\": true, \"logoImage\": \"\", \"productName\": \"TAO Portal\", \"selfRegistrationLink\": { }, \"ssoProviders\": [ ], \"templates\": [ ], \"title\": \"Log in to TAO\"}"
        },
        {
          "name": "self-registration.configuration",
          "value": "{\"backgroundImage\": \"assets/image.png\", \"backgroundImageVeil\": \"red2orange\", \"corporateText\": \"For education organizations who want the freedom to control and own their assessment experience, from content to technology to delivery to reporting, the TAO assessment platform delivers maximum flexibility, interoperability, and security.\", \"corporateTitle\": \"Accelerating Innovation in Assessment\", \"defaultCurrency\": \"EUR\", \"defaultTimeZone\": \"Europe/Luxembourg\", \"linkVisibility\": true, \"logoImage\": \"\", \"productName\": \"TAO Portal\", \"selfRegistrationLink\": { }, \"ssoProviders\": [ ], \"templates\": [ ], \"title\": \"Log in to TAO\"}"
        },
        {
          "name": "portal.backoffice.url",
          "value": "https://%s/backoffice" % [setup.publicDomain],
        },
        {
          "name": "portal.testrunner_client_id",
          "value": "portal-deliver-client-id-#tenantId#"
        },
        {
          "name": "portal.proctoring_client_id",
          "value": "portal-proctoring-client-id-#tenantId#"
        },
        {
          "name": "scoring-deliver.registration_id",
          "value": "ms--deliver-#tenantId#"
        },
        {
          "name": "portal.grader_client_id",
          "value": "portal-grader-client-id-#tenantId#"
        },
        {
          "name": "portal.authoring_client_id",
          "value": "portal-authoring-client-id-#tenantId#"
        },
        {
          "name": "simple.reports.slugs",
          "value": {
            "default": {
              "dashboard": "progress_monitoring_dashboard",
              "session": "matter_and_measurements",
              "testTaker": "matter_and_measurements_test_taker"
            }
          }
        },
        {
          "name": "multifactor.authentication",
          "value": {
            "defaultType": "email",
            "enabled": false
          }
        },
        {
          "name": "portal.csv_results_fields",
          "value": "[\"login\",\"ltiParameters.family_name\",\"ltiParameters.given_name\",\"score\",\"maxScore\",\"sessionStartTime\",\"sessionEndTime\",\"items.*.completionStatus\",\"items.*.responses\",\"items.*.outcomes\", \"ltiParameters.spec_lti_claim_custom_metadata_*\"]"
        },
        {
          "name": "proctoring.registration_id",
          "value": "deliver--proctoring"
        },
        {
          "name": "timers.configuration.thresholds",
          "value": "[{\"threshold\":600000,\"refreshRate\":30000},{\"threshold\":1000,\"refreshRate\":500}]"
        },
        {
          "name": "portal.login_validator_regex",
          "value": "{\"pattern\":\"^[\\w\\-.@]{3,64}$\",\"flags\": \"\"}"
        },

        {
          "name": "portal.sessionUserManagement",
          "value": {
            "userMergeSearch": {
              "activityLogEnabled": false,
              "filter": [],
              "resultMatchCriteria": "exactMatch",
              "userSearchableFields": [
                "login"
              ]
            }
          }
        },
        {
          "name": "portal.sessionCandidateManagement",
          "value": "{\"candidateIdentifiersStrategy\": {\"priority\": [\"metadata.user.ssn\", \"metadata.user.duf\", \"metadata.user.dnumber\", \"metadata.user.passport\", \"login\"]}, \"candidateSearch\": {\"activityLogEnabled\": false, \"filter\": [{\"field\": \"role\", \"type\": \"terms\", \"values\": [\"TEST_TAKER\"]}], \"resultMatchCriteria\": \"exactMatch\", \"userSearchableFields\": [\"metadata.ssn\", \"metadata.duf\", \"metadata.dnumber\", \"metadata.passport\", \"login\"]}}"
        },
        {
          "name": "portal.test_categories",
          "value": [
            {
              "id": "a1-b2-listening",
              "title": "A1-B2 Listening"
            },
            {
              "id": "a1-b2-reading",
              "title": "A1-B2 Reading"
            },
            {
              "id": "a1-b2-speaking",
              "title": "A1-B2 Speaking"
            },
            {
              "id": "a1-b2-writing",
              "title": "A1-B2 Writing"
            },
            {
              "id": "a1-b1-sign-language-comprehension",
              "title": "A1-B1 sign language comprehension"
            },
            {
              "id": "a1-b2-sign-language-communication",
              "title": "A1-B2 sign language communication"
            },
            {
              "id": "c1-listening-and-writing",
              "title": "C1 listening and writing"
            },
            {
              "id": "c1-reading-and-speaking",
              "title": "C1 reading and speaking"
            },
            {
              "id": "social-studies-knowledge-of-society",
              "title": "Social studies (knowledge of society)"
            },
            {
              "id": "citizenship",
              "title": "Citizenship"
            }
          ]
        }
      ],
      "featureFlags": [
        {
          "name": "TIMER_SERVICE_ENABLED",
          "value": "false"
        },
        {
          "name": "ITEM_CONTENT_UPLOAD_ENABLED",
          "value": "false"
        },
        {
          "name": "SCORING_SUBMISSION_ENABLED",
          "value": "false" //TODO FOR SCORING
        },
        {
          "name": "SCORING_OWNS_GRADING_PROGRESS",
          "value": "false" //TODO FOR SCORING
        },
        {
          "name": "DATA_STORE_ENABLE_RESULTS_TRANSFER",
          "value": "true"
        },
        {
          "name": "TESTRUNNER_READALOUD_FORCED",
          "value": "false"
        },
        {
          "name": "TIMERS_STOP_ON_DISCONNECT",
          "value": "false"
        },
        {
          "name": "acs.feature",
          "value": "true"
        },
        {
          "name": "AUTOMATIC_SESSION_SELECTION",
          "value": "true"
        },
        {
          "name": "FEATURE_FLAG_TEST_NAVIGATION_NONLINEAR_RESTRICTED",
          "value": "false"
        },
        {
          "name": "dashboardEnabled",
          "value": "true"
        },
        {
          "name": "monitoringEnabled",
          "value": "false"
        },
        {
          "name": "MINIMAL_UI_TEST_TAKER",
          "value": "false"
        },
        {
          "name": "gradingEnabled",
          "value": "false" //TODO FOR SCORING
        },
        {
          "name": "batteryEnabled",
          "value": "false"
        },
        {
          "name": "hierarchyEnabled",
          "value": "true"
        },
        {
          "name": "testsEnabled",
          "value": "true"
        },
        {
          "name": "offlineVmEnabled",
          "value": "false"
        },
        {
          "name": "earlyAdopter",
          "value": "true"
        },
        {
          "name": "emailNotificationEnabled",
          "value": "true"
        },
        {
          "name": "userEmailIsMandatory",
          "value": "false"
        },
        {
          "name": "publicSessionsEnabled",
          "value": "true"
        },
        {
          "name": "userLoginGenerationEnabled",
          "value": "true"
        },
        {
          "name": "CERTIFICATION_PRODUCT",
          "value": "false"
        },
        {
          "name": "easyPasswordEnabled",
          "value": "true"
        },
        {
          "name": "enableProctoring",
          "value": "false"
        },
        {
          "name": "supportEnabled",
          "value": "false"
        },
        {
          "name": "WORKING_PROFILES_ENABLED",
          "value": "true"
        },
        {
          "name": "ms.isSuggestedScoringEnabled",
          "value": "false"
        },
        {
          "name": "readBehindEnabled",
          "value": "true"
        }
      ],
      "ltiPlatforms": [
        {
          "audience": "https://%s/devkit/platform" % [setup.publicDomain],
          "id": "devkit-platform",
          "isInternal": false,
          "name": "DevKit LTI Platform",
          "oauth2AccessTokenUrl": "%s/lti1p3/auth/platformKey/token" % setup.apps.devkit.backend.http.url,
          "oidcAuthenticationUrl": "https://%s/devkit/lti1p3/oidc/authentication" % [setup.publicDomain],
        },
        {
          "audience": "https://%s/deliver" % [setup.publicDomain],
          "id": "nextgen-tao-deliver-be-platform",
          "isInternal": true,
          "name": "Test runner as LTI Platform",
          "oauth2AccessTokenUrl": "%s/v1/oauth2/tokens" % setup.apps["environment-management"].auth_server.http.url,
          "oidcAuthenticationUrl": "https://%s/deliver/lti1p3/oidc/authentication" % [setup.publicDomain],
        },
        {
          "audience": "https://%s/backoffice" % [setup.publicDomain],
          "id": "backoffice-platform",
          "isInternal": false,
          "name": "Backoffice LTI Platform",
          "oauth2AccessTokenUrl": "%s/taoLti/Security/oauth" % [setup.apps.construct.backend.http.url],
          "oidcAuthenticationUrl": "https://%s/backoffice/taoLti/Security/oidc" % [setup.publicDomain],
        },
        {
          "audience": "https://%s/ms-be" % [setup.publicDomain],
          "id": "ms-platform",
          "isInternal": true,
          "name": "MS LTI Platform",
          "oauth2AccessTokenUrl":  "%s/v1/oauth2/tokens" % setup.apps["environment-management"].auth_server.http.url,
          "oidcAuthenticationUrl": "https://%s/ms-be/lti1p3/oidc/authentication" % [setup.publicDomain],
        },
        {
          "audience": "https://%s/portal-be" % [setup.publicDomain],
          "id": "portal-platform",
          "isInternal": true,
          "name": "Portal LTI platform",
          "oauth2AccessTokenUrl": "http://foo.bar",
          "oidcAuthenticationUrl": "http://foo.bar"
        }
      ],
      "ltiRegistrations": [
        {
          "clientId": "devkit-deliver-be-#tenantId#",
          "deploymentIds": [
            "deploymentId"
          ],
          "id": "devkit--deliver-#tenantId#",
          "platformId": "devkit-platform",
          "platformJwksUrl": "%s/lti1p3/.well-known/jwks/primaryKeySet.json" % setup.apps.devkit.backend.http.url,
          "platformKeyChain": {},
          "toolId": "nextgen-tao-deliver-be-tool",
          "toolJwksUrl": "%s/.well-known/jwks.json" % setup.apps["environment-management"].auth_server.http.url,
          "toolKeyChain": {}
        },
        {
          "clientId": "deliver-be-devkit-#tenantId#",
          "deploymentIds": [
            "1"
          ],
          "id": "deliver--devkit-#tenantId#",
          "platformId": "nextgen-tao-deliver-be-platform",
          "platformJwksUrl": "%s/.well-known/jwks.json" % setup.apps["environment-management"].auth_server.http.url,
          "platformKeyChain": {},
          "toolId": "devkit-tool",
          "toolJwksUrl": "%s/lti1p3/.well-known/jwks/primaryKeySet.json" % setup.apps.devkit.backend.http.url,
          "toolKeyChain": {}
        },
        {
          "clientId": "devkit-manual-scoring-#tenantId#",
          "deploymentIds": [
            "1"
          ],
          "id": "devkit--ms-#tenantId#",
          "platformId": "devkit-platform",
          "platformJwksUrl": "%s/lti1p3/.well-known/jwks/primaryKeySet.json" % setup.apps.devkit.backend.http.url,
          "platformKeyChain": {},
          "toolId": "ms-tool",
          "toolJwksUrl":  "%s/.well-known/jwks.json" % setup.apps["environment-management"].auth_server.http.url,
          "toolKeyChain": {}
        },
        {
          "clientId": "manual_scoring_deliver-#tenantId#",
          "deploymentIds": [
            "1"
          ],
          "id": "ms--deliver-#tenantId#",
          "platformId": "ms-platform",
          "platformJwksUrl":  "%s/.well-known/jwks.json" % setup.apps["environment-management"].auth_server.http.url,
          "platformKeyChain": {},
          "toolId": "nextgen-tao-deliver-be-tool",
          "toolJwksUrl":  "%s/.well-known/jwks.json" % setup.apps["environment-management"].auth_server.http.url,
          "toolKeyChain": {}
        },
        {
          "clientId": "proctoring_client_id-#tenantId#",
          "deploymentIds": [
            "1"
          ],
          "id": "devkit--proctoring-#tenantId#",
          "platformId": "devkit-platform",
          "platformJwksUrl": "%s/lti1p3/.well-known/jwks/primaryKeySet.json" % setup.apps.devkit.backend.http.url,
          "platformKeyChain": {},
          "toolId": "proctoring-tool",
          "toolJwksUrl":  "%s/.well-known/jwks.json" % setup.apps["environment-management"].auth_server.http.url,
          "toolKeyChain": {}
        },
        {
          "clientId": "portal-proctoring-client-id-#tenantId#",
          "clientSecret": "secret1",
          "deploymentIds": [
            "1"
          ],
          "id": "portal--proctoring-#tenantId#",
          "isInternal": true,
          "platformId": "portal-platform",
          "platformJwksUrl":  "%s/.well-known/jwks.json" % setup.apps["environment-management"].auth_server.http.url,
          "platformKeyChain": {},
          "toolId": "proctoring-tool",
          "toolJwksUrl":  "%s/.well-known/jwks.json" % setup.apps["environment-management"].auth_server.http.url,
          "toolKeyChain": {}
        },
        {
          "clientId": "portal-deliver-client-id-#tenantId#",
          "deploymentIds": [
            "1"
          ],
          "id": "portal--deliver-#tenantId#",
          "platformId": "portal-platform",
          "platformJwksUrl":  "%s/.well-known/jwks.json" % setup.apps["environment-management"].auth_server.http.url,
          "platformKeyChain": {},
          "toolId": "nextgen-tao-deliver-be-tool",
          "toolJwksUrl":  "%s/.well-known/jwks.json" % setup.apps["environment-management"].auth_server.http.url,
          "toolKeyChain": {}
        },
        {
          "clientId": "portal-authoring-client-id-#tenantId#",
          "clientSecret": "secret1",
          "deploymentIds": [
            "1"
          ],
          "id": "portal--authoring-#tenantId#",
          "isInternal": true,
          "platformId": "portal-platform",
          "platformJwksUrl":  "%s/.well-known/jwks.json" % setup.apps["environment-management"].auth_server.http.url,
          "platformKeyChain": {},
          "tenantId": "1",
          "toolId": "authoring-tool",
          "toolJwksUrl":  "%s/.well-known/jwks.json" % setup.apps["environment-management"].auth_server.http.url,
          "toolKeyChain": {}
        },
        {
          "clientId": "portal-grader-client-id-#tenantId#",
          "clientSecret": "secret1",
          "deploymentIds": [
            "1"
          ],
          "id": "portal--grader-#tenantId#",
          "isInternal": true,
          "platformId": "portal-platform",
          "platformJwksUrl":  "%s/.well-known/jwks.json" % setup.apps["environment-management"].auth_server.http.url,
          "platformKeyChain": {},
          "tenantId": "1",
          "toolId": "ms-tool",
          "toolJwksUrl":  "%s/.well-known/jwks.json" % setup.apps["environment-management"].auth_server.http.url,
          "toolKeyChain": {}
        }
      ],
      "ltiRoleMappings": [
        {
          "clientId": "portal-deliver-client-id-#tenantId#",
          "defaultLtiRole": "http://purl.imsglobal.org/vocab/lis/v2/membership#Learner",
          "map": [
            {
              "internalRoles": [
                "ADMIN",
                "TEST_TAKER"
              ],
              "ltiRole": "http://purl.imsglobal.org/vocab/lis/v2/membership#Learner"
            }
          ]
        },
        {
          "clientId": "portal-proctoring-client-id-#tenantId#",
          "map": [
            {
              "internalRoles": [
                "ADMIN"
              ],
              "ltiRole": "http://purl.imsglobal.org/vocab/lis/v2/membership#Instructor"
            }
          ]
        },
        {
          "clientId": "portal-authoring-client-id-#tenantId#",
          "map": [
            {
              "internalRoles": [
                "ADMIN"
              ],
              "ltiRole": "http://purl.imsglobal.org/vocab/lis/v2/membership/Administrator#Developer"
            },
            {
              "internalRoles": [
                "CONTENT_CREATOR",
                "ADMIN"
              ],
              "ltiRole": "http://purl.imsglobal.org/vocab/lis/v2/membership/ContentDeveloper#ContentDeveloper"
            }
          ]
        },
        {
          "clientId": "portal-grader-client-id-#tenantId#",
          "defaultLtiRole": "http://purl.imsglobal.org/vocab/lis/v2/institution/person#Instructor",
          "map": []
        }
      ],
      "ltiTools": [
        {
          "audience": "https://%s/deliver" % [ setup.publicDomain ],
          "deepLinkingUrl": "https://%s/deliver/api/v1/lti/deep-links" % [setup.publicDomain],
          "id": "nextgen-tao-deliver-be-tool",
          "isInternal": true,
          "launchUrl": "https://%s/deliver/api/v1/auth/launch-lti-1p3" % [setup.publicDomain],
          "name": "Test runner as LTI Tool",
          "oidcInitiationUrl": "https://%s/auth-server/lti1p3/oidc/initiation" % [setup.publicDomain],
        },
        {
          "audience": "https://%s/devkit/tool" % [setup.publicDomain],
          "deepLinkingUrl": "",
          "id": "devkit-tool",
          "launchUrl": "https://%s/devkit/tool/launch" % [setup.publicDomain],
          "name": "DevKit LTI tool",
          "oidcInitiationUrl": "https://%s/devkit/lti1p3/oidc/initiation" % [setup.publicDomain]
        },
        {
          "audience": "https://%s/ms-be" % [setup.publicDomain],
          "deepLinkingUrl": "",
          "id": "ms-tool",
          "isInternal": true,
          "launchUrl": "https://%s/ms-be/api/v1/lti1p3/launch" % [setup.publicDomain],
          "name": "MS LTI Tool",
          "oidcInitiationUrl": "https://%s/auth-server/lti1p3/oidc/initiation" % [setup.publicDomain]
        },
        {
          "audience": "https://%s/pr-lti-gateway" % [setup.publicDomain],
          "deepLinkingUrl": "",
          "id": "proctoring-tool",
          "isInternal": true,
          "launchUrl": "https://%s/pr-lti-gateway/api/v1/actions/proctoring/start" % [setup.publicDomain],
          "name": "Proctoring tool",
          "oidcInitiationUrl": "https://%s/auth-server/lti1p3/oidc/initiation" % [setup.publicDomain]
        },
        {
          "audience": "https://%s/backoffice" % [setup.publicDomain],
          "deepLinkingUrl": "",
          "id": "authoring-tool",
          "isInternal": true,
          "launchUrl": "https://%s/backoffice/taoLti/AuthoringTool/launch" % [setup.publicDomain],
          "name": "Authoring tool",
          "oidcInitiationUrl": "https://%s/auth-server/lti1p3/oidc/initiation" % [setup.publicDomain]
        }
      ],
      "meta": {
        "id": "local-dev-env",
        "name": "Local Development Environment"
      },
      "oauth2Clients": [
        {
          "clientId": "launch-client-#tenantId#",
          "clientSecret": "client-secret",
          "isConfidential": true,
          "name": "Platform less launch battery",
          "scopes": [
            "launch_delivery_execution"
          ]
        },
        {
          "clientId": "admin",
          "clientSecret": "secret",
          "isConfidential": false,
          "name": "Portal Backend OAuth2 Client",
          "scopes": [
            "admin",
            "tenant-api:full-access"
          ]
        },
        {
          "clientId": "admin-#tenantId#",
          "clientSecret": "secret",
          "isConfidential": false,
          "name": "Portal Backend OAuth2 Client per tenant",
          "scopes": [
            "admin"
          ]
        },
        {
          "clientId": "devkit-deliver-be-#tenantId#",
          "clientSecret": "client-secret",
          "isConfidential": true,
          "name": "Publication OAuth2 Credentials",
          "scopes": [
            "results:post"
          ]
        },
        {
          "clientId": "deliver-be-devkit-#tenantId#",
          "clientSecret": "client-secret",
          "isConfidential": true,
          "name": "Proctoring OAuth2 Credentials",
          "scopes": [
            "https://purl.imsglobal.org/spec/lti-ap/scope/control.all"
          ]
        },
        {
          "clientId": "devkit-manual-scoring-#tenantId#",
          "clientSecret": "secret1",
          "isConfidential": false,
          "name": "Manual Scoring OAuth2 Client",
          "scopes": []
        },
        {
          "clientId": "proctoring_client_id-#tenantId#",
          "clientSecret": "secret",
          "isConfidential": true,
          "name": "Proctoring OAuth2 Credentials",
          "scopes": [
            "https://purl.imsglobal.org/spec/lti-ap/scope/control.all"
          ]
        },
        {
          "clientId": "portal-deliver-client-id-#tenantId#",
          "clientSecret": "secret1",
          "isConfidential": false,
          "name": "Portal Backend OAuth2 Client",
          "scopes": [
            "launch_delivery_execution"
          ]
        },
        {
          "clientId": "synchronizer-client-id-#tenantId#",
          "isConfidential": false,
          "name": "Synchronizer OAuth2 Client",
          "scopes": [
            "bucket:admin",
            "dynamic-access:*"
          ],
          "users": [],
          "usersSource": "PORTAL"
        },
        {
          "clientId": "internal-sync-user",
          "clientSecret": "internal-sync-user-secret",
          "isConfidential": false,
          "name": "Internal Synchronizer OAuth2 Client",
          "scopes": [
            "bucket:admin"
          ],
          "users": [],
          "usersSource": "PORTAL"
        },
        {
          "clientId": "payment-webhook-client-#tenantId#",
          "clientSecret": "payment-webhook-secret",
          "isConfidential": false,
          "name": "Payment Webhook OAuth2 Client",
          "scopes": []
        }
      ],
      "userRoles": [
        {
          "global": false,
          "name": "DATA_EXPLORER",
          "permissions": [
            {
              "resource": "portal.results",
              "scopes": [
                "view"
              ]
            },
            {
              "resource": "portal.explorer",
              "scopes": [
                "view"
              ]
            }
          ]
        },
        {
          "global": false,
          "name": "DATA_EXPLORER_PORTAL_ENTITY",
          "permissions": [
            {
              "resource": "portal.explorer-entity",
              "scopes": [
                "edit",
                "view"
              ]
            },
            {
              "resource": "portal.results",
              "scopes": [
                "view"
              ]
            },
            {
              "resource": "portal.explorer",
              "scopes": [
                "view"
              ]
            }
          ]
        },
        {
          "global": false,
          "name": "DATA_EXPLORER_LOG",
          "permissions": [
            {
              "resource": "portal.explorer-log",
              "scopes": [
                "edit",
                "view"
              ]
            },
            {
              "resource": "portal.results",
              "scopes": [
                "view"
              ]
            },
            {
              "resource": "portal.explorer",
              "scopes": [
                "view"
              ]
            }
          ]
        },
        {
          "global": false,
          "name": "DATA_EXPLORER_VIEW_MANAGER",
          "permissions": [
            {
              "resource": "portal.explorer-view",
              "scopes": [
                "create"
              ]
            },
            {
              "resource": "portal.results",
              "scopes": [
                "view"
              ]
            },
            {
              "resource": "portal.explorer",
              "scopes": [
                "view"
              ]
            }
          ]
        },
        {
          "global": false,
          "name": "DATA_EXPLORER_DATA_EXPORTER",
          "permissions": [
            {
              "resource": "portal.explorer-data",
              "scopes": [
                "create"
              ]
            },
            {
              "resource": "portal.results",
              "scopes": [
                "view"
              ]
            },
            {
              "resource": "portal.explorer",
              "scopes": [
                "view"
              ]
            }
          ]
        },
        {
          "global": true,
          "name": "ADMIN",
          "permissions": [
            {
              "resource": "any",
              "scopes": [
                "all"
              ]
            }
          ],
          "restrictions": [
            {
              "resource": "portal.my-session",
              "scopes": [
                "view"
              ]
            },
            {
              "resource": "portal.system-settings",
              "scopes": [
                "create",
                "view",
                "edit",
                "delete"
              ]
            }
          ]
        },
        {
          "global": true,
          "name": "CONTENT_CREATOR",
          "permissions": [
            {
              "resource": "portal.content-bank",
              "scopes": [
                "view"
              ]
            }
          ]
        },
        {
          "global": true,
          "name": "DASHBOARD_VIEWER",
          "permissions": [
            {
              "resource": "portal.dashboard",
              "scopes": [
                "view"
              ]
            }
          ]
        },
        {
          "global": true,
          "name": "GROUP_CREATOR",
          "permissions": [
            {
              "resource": "portal.group",
              "scopes": [
                "view",
                "create"
              ]
            }
          ]
        },
        {
          "global": false,
          "name": "GROUP_MANAGER",
          "permissions": [
            {
              "resource": "portal.group",
              "scopes": [
                "view",
                "edit",
                "delete"
              ]
            },
            {
              "resource": "portal.session",
              "scopes": [
                "create",
                "view",
                "edit",
                "delete",
                "grade",
                "review-grade",
                "reopen-grade"
              ]
            },
            {
              "resource": "portal.review-session",
              "scopes": [
                "view",
                "edit"
              ]
            },
            {
              "resource": "portal.custom-reports",
              "scopes": [
                "view"
              ]
            },
            {
              "resource": "portal.csv-export",
              "scopes": [
                "view"
              ]
            },
            {
              "resource": "portal.session-report",
              "scopes": [
                "view"
              ]
            }
          ]
        },
        {
          "global": false,
          "name": "GRADER",
          "permissions": [
            {
              "resource": "portal.session",
              "scopes": [
                "view",
                "grade"
              ]
            }
          ]
        },
        {
          "global": false,
          "name": "TEST_TAKER",
          "permissions": [
            {
              "resource": "portal.my-session",
              "scopes": [
                "view",
                "review"
              ]
            },
            {
              "resource": "portal.review-session",
              "scopes": [
                "view",
                "edit"
              ]
            },
            {
              "resource": "portal.payment",
              "scopes": [
                "create"
              ]
            },
            {
              "resource": "portal.report",
              "scopes": [
                "view"
              ]
            }
          ]
        },
        {
          "global": true,
          "label": "Battery manager",
          "name": "BATTERY",
          "permissions": [
            {
              "resource": "portal.battery",
              "scopes": [
                "create",
                "view",
                "edit",
                "delete"
              ]
            }
          ]
        },
        {
          "global": false,
          "name": "REVIEW_GRADER",
          "permissions": [
            {
              "resource": "portal.session",
              "scopes": [
                "view",
                "review-grade"
              ]
            }
          ]
        },
        {
          "global": true,
          "name": "PUBLIC_SESSION_MANAGER",
          "permissions": [
            {
              "resource": "portal.public-session",
              "scopes": [
                "create",
                "view",
                "edit",
                "delete"
              ]
            }
          ]
        },
        {
          "global": true,
          "name": "SYSTEM_MANAGER",
          "permissions": [
            {
              "resource": "portal.system-settings",
              "scopes": [
                "edit"
              ]
            }
          ]
        },
        {
          "global": false,
          "name": "WORKING_PROFILES_MANAGER",
          "permissions": [
            {
              "resource": "portal.user.working-profiles",
              "scopes": [
                "all"
              ]
            }
          ]
        },
        {
          "global": true,
          "name": "SUPPORT",
          "permissions": [
            {
              "resource": "portal.support",
              "scopes": [
                "all"
              ]
            }
          ]
        }
      ]
    }
  ]
}
