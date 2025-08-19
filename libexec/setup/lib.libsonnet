{
    local lib = self,

    address(x)::
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
            url: std.rstripChars('%s/%s' % [this.baseUrl, this.prefix],'/'),
        },

    toEnv(o,pfx=[],)::
        local name = std.join("_", pfx);
        std.get({
            object: std.foldl(
                        function(t,x) 
                            t + lib.toEnv(o[x], pfx=pfx+[x]),
                        std.objectFields(o),
                        {},
            ),
            array: std.foldl(
                        function(t,x)
                            t + lib.toEnv(o[x], pfx=pfx+[""+x]),
                        std.range(0, std.length(o)-1),
                        {},
            ),
        },std.type(o),default={[name]: o}),

    upcaseKeys(o)::
        if std.type(o) == "object"
        then std.foldl(
            function(t,x)
                t+{ [std.strReplace(std.asciiUpper(x),'-','_')]: o[x] },
            std.objectFields(o),
            {},
        )
        else o,
    
    toEnvFile(o,pfx=[])::
        std.join("\n",std.objectValues(std.mapWithKey(
            function(k,v) "%s=%s" % [k, std.escapeStringBash(v),],
            lib.upcaseKeys(lib.toEnv(o,pfx)),
        )))+"\n"
}
