local templates = {
    portal: (import './apps/portal.libsonnet'),
    em: (import './apps/environment-management.libsonnet'),
    hierarchy: (import './apps/hierarchy.libsonnet'),
    datastore: (import './apps/datastore.libsonnet'),
    deliver: (import './apps/deliver.libsonnet'),
    devkit: (import './apps/devkit.libsonnet'),
    'task-orchestrator': (import './apps/task-orchestrator.libsonnet'),
    'dynamic-query': (import './apps/dynamic-query.libsonnet'),
    // sr: (import '../../../apps/setup/src/assets/apps/simple-reports.libsonnet'),
    timers: (import './apps/timers.libsonnet'),
    aaaaaaa: (import './apps/timers.libsonnet'),
    construct: (import './apps/construct.libsonnet'),
};

local lib = import './lib.libsonnet';
local addresses = import './addresses.libsonnet';


local hydrateSetup(seed) = {
    portal: { populate: 'demo-AQ' },
    dirs: {
        opt:    '/opt/tao-ce',
        varlib: '/var/lib/tao-ce',
        etc:    '/etc/tao-ce',
        libexec:'/usr/local/libexec/tao-ce',
        data:   '%(varlib)s/data' % self,
        envs:   '%(etc)s/setup/envs' % self,
        files:  '%(etc)s/setup/config' % self,
    },
} + seed.spec + {
        local this=self,

        env+: {
            GOOGLE_CLOUD_PROJECT: 'demo-tao',
            GOOGLE_APPLICATION_CREDENTIALS: "%s/config/gcp.json" % this.dirs.etc,
            TAO_CE_PUBLIC_DOMAIN: this.publicDomain,
        },
        dependencies: 
            std.foldl(
                function(t,x)
                    t + {[x.key]: x + {address: lib.address(x.address)},},
                super.dependencies,
                {},
            ),
        apps: addresses,
    };


function(seed)
    local setup = hydrateSetup(std.parseYaml(seed));
std.foldl(
    function(t,x)
        local h = templates[x](setup);
        local envs = std.get(h, 'env', {});
        local files = std.get(h, 'files', {});
        local pubsubs = std.get(h, 'pubsub', []);
        
        t 
        + std.foldl(
            function(s,k) s + { ["envs/%s/%s.env" % [x,k]]: lib.toEnvFile(envs[k]) },
            std.objectFields(envs),
            {},
            )
        + std.foldl(
            function(s,k) s + { ["config/%s/%s" % [x,k]]: files[k] },
            std.objectFields(files),
            {},
            )
        + { ["pubsub/%s.json" % x]: std.manifestJson(pubsubs) }
        ,
        std.objectFields(templates),
        {},
)
+ {
    "envs/dir.env": lib.toEnvFile(setup.dirs,['tao','ce','dir']),
    "envs/svc.env": 
        lib.toEnvFile(setup.env,[])
        + lib.toEnvFile(setup.apps+{deps: std.mapWithKey(function(k,v) v.address, setup.dependencies)},['tao','ce','svc']),
}
