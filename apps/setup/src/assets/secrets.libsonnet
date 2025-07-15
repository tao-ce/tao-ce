local templates = [
    (import './apps/tao.libsonnet'),
    (import './apps/datastore.libsonnet'),
    (import './apps/deliver.libsonnet'),
    (import './apps/devkit.libsonnet'),
    (import './apps/dynamic-query.libsonnet'),
    (import './apps/environment-management.libsonnet'),
    (import './apps/hierarchy.libsonnet'),
    (import './apps/portal.libsonnet'),
    (import './apps/simple-reports.libsonnet'),
    (import './apps/task-orchestrator.libsonnet'),
    (import './apps/timers.libsonnet'),
    (import './services/pubsub-config.libsonnet'),
];


function(setup)
    std.objectValues(
        std.mapWithKey(
            function(k,v)
                {
                    apiVersion: 'v1', 
                    kind: 'Secret', 
                    metadata: { 
                        name: k,
                        namespace: setup.resourcesNamespace,
                    },
                    stringData: v,
                },
            std.foldl(
                function(t,x)
                    t + x(setup),
                    templates,
                    {},
            ) 
        )
    )