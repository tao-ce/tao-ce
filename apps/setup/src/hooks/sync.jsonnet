local address(x) =
    {schema: 'tcp', host: '0.0.0.0', port: 0, prefix: '', } 
    + x 
    + {
        local this = self,
        schemaPort:: std.get({
                'http': 80,
                'https': 443,
                'redis': 6379,
                'pgsql': 5432,
                'mysql': 3306,
            }, self.schema, default=0),

        port: if super.port <= 0 then this.schemaPort else super.port,
        isStandardPort:: this.port > 0 && this.port == this.schemaPort,

        endpoint: if this.isStandardPort then this.host else this.fullEndpoint, 
        fullEndpoint: '%s:%d' % [this.host, this.port],
        baseUrl: '%s://%s' % [this.schema, this.endpoint],
        url: '%s/%s' % [this.baseUrl, this.prefix],
    }
;

local hydrate(setup) =
    setup.spec + {
        pfx: 'tao-ce-setup-',
        env:
            std.foldl(
                function(t,x)
                    t + {[x.name]: x.value,},
                setup.spec.env,
                {},
            ),
        dependencies: 
            std.foldl(
                function(t,x)
                    t + {[x.key]: x + {address: address(x.address)},},
                setup.spec.dependencies,
                {},
            ),
    }
;



function(request)

    local setup = hydrate(request.parent);

{
    status: {},
    children:
        [
            {
                apiVersion: "v1",
                kind: "Secret",
                metadata: {
                    name: '%s-debug' % request.parent.metadata.name,
                    namespace: setup.resourcesNamespace,
                },
                stringData: {
                    setup: std.manifestJson(setup),
                    },
            },
        ]
        + (import '/assets/secrets.libsonnet')(setup)
        ,
}