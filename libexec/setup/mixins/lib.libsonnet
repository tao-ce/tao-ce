local asRole(role) = role {
  permissions+: [],
  restrictions+: [],

  hasPermission(resource, scope)::
    std.any(
      std.map(
        function(p)
          std.get(p, 'resource') == resource
          && std.setMember(
            scope,
            std.set(std.get(p, 'scopes', []))
          ),
        super.permissions
      )
    )
  ,

  removePermission(resource)::
    self {
      permissions: std.filter(
        function(p) std.get(p, 'resource') != resource,
        super.permissions
      ),
    },

  setPermission(resource, scopes)::
    self.removePermission(resource) + {
      permissions+: [{ resource: resource, scopes: scopes }],
    },

  removeRestriction(resource)::
    self {
      restrictions: std.filter(
        function(r) std.get(r, 'resource') != resource,
        super.restrictions
      ),
    },

  setRestriction(resource, scopes)::
    self.removeRestriction(resource) + {
      restrictions+: [{ resource: resource, scopes: scopes }],
    },
};

local asEnvironment(environment) = environment {
  userRoles+: [],
  featureFlags+: [],
  configurations+: [],
  updateRoles(fn)::
    self {
      userRoles: std.map(function(r) fn(r), super.userRoles),
    },

  removeFeatureFlag(flag)::
    self {
      featureFlags: std.filter(function(f) f.name != flag, super.featureFlags),
    },

  setFeatureFlag(flag, value)::
    self.removeFeatureFlag(flag) + {
      featureFlags+: [{ name: flag, value: value }],
    },
  removeConfiguration(configuration)::
    self {
      configurations: std.filter(function(c) c.name != configuration, super.configurations),
    },

  setConfiguration(configuration, value)::
    self.removeConfiguration(configuration) + {
      configurations+: [{ name: configuration, value: value }],
    },

};

{
  asRole:: asRole,
  asEnvironment:: asEnvironment,
  mixin:: {
    patches+:: [],
    apply(context):: std.foldl(function(e, p) p(e), self.patches, context),
  },
}
