


local config = {
    local random = (import "./random.libsonnet")(config.seed),
    tenantId: '1',
    hierarchyRoot: 'Root',
    indices: {
        user: 'portal-user',
        hierarchy: 'portal-hierarchy',
        hierarchyConfig: 'portal-config-hierarchy',
        group: 'portal-enrolment',
    },
    data: {
        hierarchy: {
                name:: "TAO CE",
                admins:: [{name: 'TAO Administrator', login: 'admin'}],
                        local this = self,
                        local all_users = this.testtakers,
                        
                        groups:: [
                            {
                                groupName: 'AQ %s' % n,
                                groupDescription: 'AQ %s' % n,
                                roles:: {
                                    test_taker: [ random.pick("pick-g%s-%d" % [n, i], all_users) for i in std.range(2,2+random.int("g-%s" % [n], mod=20))],
                                },
                            }
                            for n in ['A', 'B', 'C', 'D', 'E', 'F']
                        ],

                        testtakers:: []
                            + [{name: 'Terres Australes %02d' % i, login: 'tf%02d' % i} for i in std.range(1,10)]
                            + [{name: 'South Georgia %02d' % i, login: 'gs%02d' % i} for i in std.range(1,10)]
                            + [{name: 'Falklands %02d' % i, login: 'fk%02d' % i} for i in std.range(1,10)]
                            + [{name: 'Heard Island %02d' % i, login: 'hm%02d' % i} for i in std.range(1,10)]
                            ,
            }
    },
    seed: "",
};

local portal = (import './portal.libsonnet')(config);

portal.hierarchy(config.data.hierarchy).fn.render

