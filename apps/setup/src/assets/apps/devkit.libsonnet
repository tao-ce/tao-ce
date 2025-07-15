function(setup)
{
  ['%(pfx)sdevkit-lti1p3-env' % setup]: {
        APP_DEBUG: "true",
        APP_ENV: "prod",
        APP_HOST: "https://%s/devkit/" % [setup.publicDomain],
        REDIS_CACHE_DSN: setup.dependencies.redis.address.url,
        XDEBUG_MODE: "off",
        HTTPS: "on",
  },
    ['%(pfx)sdevkit-lti1p3-keys' % setup]: {
        'private.pem': importstr './keys/devkit/private.key',
        'public.pem': importstr './keys/devkit/public.key',
    },

  ['%(pfx)sdevkit-lti1p3-config' % setup]: {
        'lti1p3.yaml': std.strReplace(importstr './files/lti1p3.yaml', 'community.tao.internal', setup.publicDomain),
  },
}