function(setup)
std.parseYaml(importstr './lti1p3.yaml')
+ {
    lti1p3+: {
            platforms+: {
                deliverPlatform+: {
                    audience: setup.publicDomain +  '/deliver',
                    oauth2_access_token_url: "%s/lti1p3/auth/primaryKeyPair/token" % setup.apps["environment-management"].auth_server.http.url,
                    oidc_authentication_url: "https://%s/deliver/lti1p3/oidc/authentication" % setup.publicDomain,
            
                },
                devkitPlatform+: {
                    audience: setup.publicDomain +  '/devkit/platform',
                    oauth2_access_token_url: "%s/lti1p3/auth/primaryKeyPair/token" % setup.apps.devkit.backend.http.url,
                    oidc_authentication_url: "https://%s/devkit/lti1p3/oidc/authentication" % setup.publicDomain,
            
                },
            },
            registrations+: {
                "deliver--devkit"+: {
                    platform_jwks_url: "%s/lti1p3/.well-known/jwks/primaryKeySet.json" % setup.apps.devkit.backend.http.url,
                    tool_jwks_url: "%s/lti1p3/.well-known/jwks/primaryKeySet.json" % setup.apps["environment-management"].auth_server.http.url,

                },
                "devkit--backoffice"+: {
                    platform_jwks_url: "%s/lti1p3/.well-known/jwks/primaryKeySet.json" % setup.apps.devkit.backend.http.url,
                    tool_jwks_url: "%s/taoLti/Security/jwks" % setup.apps.construct.backend.http.url,
                },
                "devkit-deliver"+: {
                    platform_jwks_url: "%s/lti1p3/.well-known/jwks/primaryKeySet.json" % setup.apps.devkit.backend.http.url,
                    tool_jwks_url: "%s/lti1p3/.well-known/jwks/primaryKeySet.json" % setup.apps["environment-management"].auth_server.http.url,
                },
                "devkit--devkit"+: {
                    platform_jwks_url: "%s/lti1p3/.well-known/jwks/primaryKeySet.json" % setup.apps.devkit.backend.http.url,
                    tool_jwks_url: self.platform_jwks_url,
                },
                //TODO
                // "devkit--ms"
                // "devkit--proctoring"
            },
            tools+: {
                deliverTool+: {
                    audience: std.strReplace(super.audience,"community.tao.internal",setup.publicDomain),
                    deep_linking_url: std.strReplace(super.deep_linking_url,"community.tao.internal",setup.publicDomain),
                    launch_url: std.strReplace(super.launch_url,"community.tao.internal",setup.publicDomain),
                    oidc_initiation_url: std.strReplace(super.oidc_initiation_url,"community.tao.internal",setup.publicDomain),
                },
                devkitTool+: {
                    audience: std.strReplace(super.audience,"community.tao.internal",setup.publicDomain),
                    deep_linking_url: std.strReplace(super.deep_linking_url,"community.tao.internal",setup.publicDomain),
                    launch_url: std.strReplace(super.launch_url,"community.tao.internal",setup.publicDomain),
                    oidc_initiation_url: std.strReplace(super.oidc_initiation_url,"community.tao.internal",setup.publicDomain),
                },
                manualScoringTool+: {
                    audience: std.strReplace(super.audience,"community.tao.internal",setup.publicDomain),
                    deep_linking_url: std.strReplace(super.deep_linking_url,"community.tao.internal",setup.publicDomain),
                    launch_url: std.strReplace(super.launch_url,"community.tao.internal",setup.publicDomain),
                    oidc_initiation_url: std.strReplace(super.oidc_initiation_url,"community.tao.internal",setup.publicDomain),
                },
                proctoringTool+: {
                    audience: std.strReplace(super.audience,"community.tao.internal",setup.publicDomain),
                    deep_linking_url: std.strReplace(super.deep_linking_url,"community.tao.internal",setup.publicDomain),
                    launch_url: std.strReplace(super.launch_url,"community.tao.internal",setup.publicDomain),
                    oidc_initiation_url: std.strReplace(super.oidc_initiation_url,"community.tao.internal",setup.publicDomain),
                },
                taoBackofficeTool+: {
                    audience: std.strReplace(super.audience,"community.tao.internal",setup.publicDomain),
                    deep_linking_url: std.strReplace(super.deep_linking_url,"community.tao.internal",setup.publicDomain),
                    launch_url: std.strReplace(super.launch_url,"community.tao.internal",setup.publicDomain),
                    oidc_initiation_url: std.strReplace(super.oidc_initiation_url,"community.tao.internal",setup.publicDomain),
                },
            }
        }
    }

