function(setup) 
{
    local this = self,
    setup:: setup,
    addresses:: setup.apps[this.id],
    id:: error('id is required'),
    fn:: {
        healthchecks:: {
            local checkname(tier, address) = '%s-%s-%s' % [this.id, tier, address],
            http(tier, address, path="/health", method="GET"): {
                http+: {
                    [checkname(tier, address)]: {
                        meta: {app: this.id, tier: tier, address: address},
                        status: {and: [{le: 299}, {ge: 200}]},
                        method: method,
                        timeout: 5000,
                        url: this.addresses[tier][address].url + path,
                    },
                },
            },
            tcp(tier,address): {
                addr+: {
                    [checkname(tier, address)]: {
                        meta: {app: this.id, tier: tier, address: address},
                        reachable: true,
                        timeout: 5000,
                        address: this.addresses[tier][address].url
                    },
                },
            },
        }
    },
    env: {},
    files: {},
    pubsub: [],
    healthchecks: {},
}