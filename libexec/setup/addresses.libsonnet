local lib = import './lib.libsonnet';
local localAddress(p) = lib.address({schema: 'http', host: 'localhost', port: p, prefix: '', });

{
    "environment-management": {
        auth_server: {
            http: localAddress(21100), // auth-server:8080
            gw: localAddress(21101),    //auth-server:8888
            grpc: localAddress(21102),  //auth-server:1888
        },
        lti_gateway: {
            http: localAddress(21103), //lti-gw:80
        },
        envoy: {
            http: localAddress(21104), //envoy:80
        },
        sidecar: {
            http: localAddress(21105), //sidecar:8080
            grpc: localAddress(21106), //sidecar:18084
        },
    },
    portal: {
        backend: {
            http: localAddress(21200), //portal-be:3000
        },
        bootstrap: {
            http: localAddress(21201), //portal-bootstrap:3000
        },
        static: {
            http: localAddress(21202), //portal-static:8080
        },
    },
    hierarchy: {
        backend: {
            http: localAddress(21900), //hierarchy-be:3001
        },
    },
    deliver: {
        backend: {
            http: localAddress(21300), //deliver-be:80
        },
        bootstrap: {
            http: localAddress(21301), //deliver-bootstrap:3000
        },
        static: {
            http: localAddress(21302), //deliver-static:8080
        },
        sandbox: {
            http: localAddress(21303), //deliver-sandbox:3000
        },
    },
    construct: {
        backend: {
            http: localAddress(21304), //construct:8080
        },
    },
    devkit: {
        backend: {
            http: localAddress(21305), //devkit:80
        },
    },
    dynamic_query: {
        api: {
            http: localAddress(21901), //dynamic-query-api:3000
        },
    },
    task_orchestrator: {
        backend: {
            http: localAddress(21902), //task-orchestrator:8080
            socket: localAddress(21903), //task-orchestrator:3000
        },
    },
    timers: {
        backend: {
            http: localAddress(21904), //timers:8080
            socket: localAddress(21905), //timers:3000
        },
    },
}