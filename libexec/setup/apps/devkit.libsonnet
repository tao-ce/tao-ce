function(setup)

{
    files: {
        'private.pem': importstr './keys/devkit/private.key',
        'public.pem': importstr './keys/devkit/public.key',
        'lti1p3.yaml': std.manifestYamlDoc((import './files/lti1p3.libsonnet')(setup),quote_keys=false),
    },
    env: {
        backend: {
            APP_DEBUG: "true",
            APP_ENV: "prod",
            APP_HOST: "https://%s/devkit/" % [setup.publicDomain],
            REDIS_CACHE_DSN: setup.dependencies.redis.address.url,
            XDEBUG_MODE: "off",
            HTTPS: "on",
            LISTEN_PORT: setup.apps.devkit.backend.http.port,
        }
    },

}
