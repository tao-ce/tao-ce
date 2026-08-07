local templates = {
  portal: (import './apps/portal.libsonnet'),
  em: (import './apps/environment-management.libsonnet'),
  datastore: (import './apps/datastore.libsonnet'),
  deliver: (import './apps/deliver.libsonnet'),
  devkit: (import './apps/devkit.libsonnet'),
  'task-orchestrator': (import './apps/task-orchestrator.libsonnet'),
  'dynamic-query': (import './apps/dynamic-query.libsonnet'),
  timers: (import './apps/timers.libsonnet'),
  construct: (import './apps/construct.libsonnet'),
  proctoring: (import './apps/proctoring.libsonnet'),
  'content-service': (import './apps/content-service.libsonnet'),
  scoring: (import './apps/scoring.libsonnet'),
};

local addresses = import './addresses.libsonnet';

local hydrateSetup(seed, salt, release_flavor) =
  local lib = (import './lib.libsonnet') { salt:: salt };
  {
    lib:: lib,
    defaultLocale: 'en-US',
    portal: { populate: 'admin+demo5' },
    flavor: release_flavor,
    features+: [],
    dirs: {
      opt: '/opt/tao-ce',
      varlib: '/var/lib/tao-ce',
      etc: '/etc/tao-ce',
      libexec: '/usr/local/libexec/tao-ce',
      data: '%(varlib)s/data' % self,
      setup: '%(etc)s/setup' % self,
      envs: '%(setup)s/envs' % self,
      files: '%(setup)s/config' % self,
      pki: '%(varlib)s/pki' % self,
      keys: '%(pki)s/keys' % self,
    },
  } + seed.spec + {
    local this = self,

    env+: {
      GOOGLE_CLOUD_PROJECT: 'demo-tao',
      GOOGLE_APPLICATION_CREDENTIALS: '%s/config/gcp.json' % this.dirs.etc,
      TAO_CE_PUBLIC_DOMAIN: this.publicDomain,
      GOOGLE_APP_NAMESPACE: 'oat-dev',
      NODE_VERSION: '24',
    },
    dependencies:
      std.foldl(
        function(t, x)
          t { [x.key]: x { address: lib.address(x.address) } },
        super.dependencies,
        {},
      ),
    apps: addresses,
    mixins: (import './mixins/main.libsonnet')(self),
  };


function(seed, salt=importstr '/proc/sys/kernel/random/uuid', release_flavor='full')
  local setup = hydrateSetup(std.parseYaml(seed), salt, release_flavor);
  local keepApps = setup.mixins.fn.keepApps(std.objectFields(templates));

  local apps = std.mapWithKey(function(k, v)
                                (import './apps/skel.libsonnet')(setup)
                                + { id:: k }
                                + v(setup),
                              templates);

  std.foldl(
    function(t, x)
      local h = apps[x];
      t
      + std.foldl(
        function(s, k) s { ['envs/%s/%s.env' % [x, k]]: setup.lib.toEnvFile(h.env[k]) },
        std.objectFields(h.env),
        {},
      )
      + std.foldl(
        function(s, k) s { ['config/%s/%s' % [x, k]]: h.files[k] },
        std.objectFields(h.files),
        {},
      )
      + { ['pubsub/%s.json' % x]: std.manifestJson(h.pubsub) }
      + { ['healthcheck.d/%s.yml' % x]: std.manifestYamlDoc(h.healthchecks) }
    ,
    keepApps,
    {},
  )
  + { 'healthcheck.yml': std.manifestYamlDoc({
    gossfile: std.foldl(
      function(s, a) s { [a]: { file: 'healthcheck.d/%s.yml' % a } },
      keepApps,
      {},
    ),
  }) }
  + {
    'scripts/wipe/es.sh': |||
      #!/bin/sh
      echo '{"transient": {"action.destructive_requires_name": false}}' | curl -H "Content-Type: application/json" -d@- -k -X PUT "%(baseUrl)s/_cluster/settings"
      curl -k -X DELETE "%(baseUrl)s/*"
    ||| % setup.dependencies.es.address,
    'scripts/wipe/data.sh': |||
      #!/bin/sh
      rm -rf --preserve-root /%(varlib)s/*
    ||| % setup.dirs,
    'scripts/wipe/config.sh': |||
      #!/bin/sh
      rm -rf --preserve-root %(setup)s/*
    ||| % setup.dirs,
    'envs/dir.env': setup.lib.toEnvFile(setup.dirs, ['tao', 'ce', 'dir']),
    'envs/svc.env':
      setup.lib.toEnvFile(setup.env, [])
      + setup.lib.toEnvFile(setup.apps { deps: std.mapWithKey(function(k, v) v.address, setup.dependencies) }, ['tao', 'ce', 'svc']),
  }
