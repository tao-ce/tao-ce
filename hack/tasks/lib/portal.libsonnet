


function(config) 

local pick(collection, count=1, salt=config.seed) =
    std.sha256(salt);

local uuid(d, salt=config.seed) =
    local sha = std.sha256(salt + std.toString(d));
    std.join("-", [
        sha[0:7],
        sha[8:11],
        sha[12:15],
        sha[16:19],
        sha[20:31],]);

{

    local portal = self,

    local skel(class="",name="") = {
        local this = self,
        _class:: class,
        _name:: name,
        _index:: config.indices[class],
        id::  uuid("%s/%s/%s" % [this._class, config.tenantId, this._name]),
        fn:: {
            render_index:: { index: { _index: this._index, _id: this.id }},
            render:: [
                this.fn.render_index,
                this,
                ],
        },
    },

    group:: function(g, hierarchy=null)
        skel("group", g.groupName) {
            local this = self,

            groupId: self.id,
            hierarchiesLevels: hierarchy.hierarchiesLevels,
            hierarchyPath: hierarchy.hierarchyPath,
            active: true,
            groupActive: true,
            groupHidden: false,
            tenantId: config.tenantId,

            resources:: {
                all:: self.memberships + self.sessions,
                sessions:: 
                    local sessions = std.get(g, 'sessions', [], true);

                    std.foldl(
                        function(t,s)
                        t + [
                            skel("session-test-taker", "%s" % [ s.sessionName]) + this + s {
                                    _index:: config.indices.group,
                                    id:: "%s" % [self.sessionId],
                                   sessionId: uuid("%s%s" % [ s.sessionName, this.groupId]),
                                                                   resources:: { all:: [], },

                                   startDate: null,
                                   endDate: null,
                                   gradesNotificationStartDate: null,
                                   timezone: "UTC",
                                   isCertificationSession: false,
                                   location: "",
                                   room: "",
                                   currency: "EUR",
                                   gradingRequired: false,
                                   deliveryExecutionStatus: "initial",
                                   deliveryGradingStatus: "graded",
                                }
                        ] 
                        
                        
                        +
                        std.map(
                            function(u)
                                skel("session-test-taker", "%s/%s" % [u.login, s.sessionName]) + u + s {
                                    _index:: config.indices.group,
                                    id:: "%s%s" % [self.sessionId, u.login],
                                   sessionId: uuid("%s%s" % [s.sessionName, this.groupId]),
                                   startDate: null,
                                   endDate: null,
                                   gradesNotificationStartDate: null,
                                   timezone: "UTC",
                                   isCertificationSession: false,
                                   deliveryExecutionStatus: "initial",
                                   deliveryGradingStatus: "graded",

                                }
                            , this.resources.memberships),
                            sessions,
                            [],
                    )
                ,
                memberships::
                    local roles = std.get(g,'roles',{},true);
                    local test_taker = std.get(roles,'test_taker',[],true);

                    std.map(
                        function(u)
                            skel("test-taker",u.login) + this + u +
                            {
                                _index:: config.indices.group,
                                id:: "%sTEST_TAKER%s" % [this.id, u.login],
                                groupId: this.id,
                                resources:: { all:: [], },
                                groupRole: 'TEST_TAKER',
                            }
                        ,test_taker),
            },

            fn+:: {
                render+:: std.foldl( function(t,x) t + x.fn.render, this.resources.all, [] ),
            },
        } + g,

    user:: function(u, hierarchy=null)
        skel("user", u.login)
        {
            id:: "%s%s" % [config.tenantId, u.login],
            password: "$2a$06$rRk8eg55gva762yOCh2sHeIuuq9NynzPPPQ45JxhoOtum4ZqgTRui", // just "password"
            hierarchy: { Root: hierarchy.organizationId },
            hierarchyLevel: { Root: hierarchy.hierarchyLevel },
            tenantId: config.tenantId,
            active: true,
        } + u,

    testtaker:: function(u, hierarchy=null)
        self.user(u, hierarchy) + {
        workingProfiles+: [
            { 
                role: [ "TEST_TAKER"],
                hierarchy: { Root: hierarchy.organizationId },
                hierarchyLevel: { Root: hierarchy.hierarchyLevel },
                name: "profile-test-taker-%s" % hierarchy.organizationId,
            }],},

    admin:: function(u, hierarchy=null)
        self.user(u, hierarchy) + {
        workingProfiles+: [
            { 
                role: [ "ADMIN", "SYSTEM_MANAGER"],
                hierarchy: { Root: hierarchy.organizationId },
                hierarchyLevel: { Root: hierarchy.hierarchyLevel },
                name: "profile-backoffice"
            }],},

    hierarchy:: function(h, parent=null) 
        skel("hierarchy", h.name) {
            local this = self,
            
            local level(i) = "Level%d" % i,

            _index:: config.indices.hierarchy,
            _config:: {
                _index:: { index: { _index: config.indices.hierarchyConfig, _id: "%s-%s" % [config.tenantId, config.hierarchyRoot] }},
                tenantId: config.tenantId,
                hierarchyName: config.hierarchyRoot,
                hierarchyLevels: [ "Level%d" % i for i in std.range(1,15) ],
                hierarchyId: config.hierarchyRoot,
            },
            isRoot::  (parent == null),
            id:: "%s-%s-%s" % 
                    if this.isRoot 
                    then [config.tenantId, config.hierarchyRoot, config.hierarchyRoot]
                    else [config.tenantId, this.organizationId, parent.hierarchyId],

            organizationName: h.name,
            parentOrganizationId: if self.isRoot then null else parent.organizationId,
            organizationId: if self.isRoot 
                then config.hierarchyRoot
                else uuid("org-%s-%s" % [parent.id, this.organizationName]),
            
            organizationDescription: null,
            tenantId: config.tenantId,
            disabled: false,

            parentHierarchyLevelInt:: if this.isRoot then 0 else parent.hierarchyLevelInt,
            hierarchyLevelInt:: this.parentHierarchyLevelInt + 1,
            hierarchyLevel: level(this.hierarchyLevelInt),
            nextLevelInt:: this.hierarchyLevelInt + 1,
            nextHierarchyLevel: level(this.nextLevelInt),

            hierarchyId: if this.isRoot then config.hierarchyRoot else parent.hierarchyId,
            hierarchiesLevels: (if this.isRoot then {} else parent.hierarchiesLevels) + {
                Root+: [this.organizationId],
            },
            hierarchyPath: {
                Root: 
                    { [this.hierarchyLevel]: this.organizationId }
                    + ( if this.isRoot 
                        then {} 
                        else parent.hierarchyPath.Root
                    ),
            },

            fn+:: {
                render+:: std.foldl(
                    function(t,x) t + x.fn.render,
                    this.resources.all,
                    if this.isRoot 
                        then [
                            this._config._index,
                            this._config,
                        ]
                        else []),
            },

            resources:: {
                all:: []
                    + self.hierarchies 
                    + self.admins
                    + self.users
                    + self.groups
                ,
                hierarchies:: std.map(
                        function(x) portal.hierarchy(h[x],this),
                        std.objectFields(h)),
                admins:: std.map(
                        function(x) portal.admin(x,this),
                        std.get(h,'admins',[],true)),
                users:: std.map(
                        function(x) portal.testtaker(x,this),
                        std.get(h,'testtakers',[],true)),
                groups:: std.map(
                        function(x) portal.group(x,this),
                        std.get(h,'groups',[],true)),

            }
        },
}
