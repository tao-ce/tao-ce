local lib = import 'lib.libsonnet';

local flavors = {
  full: (import 'flavors/full.libsonnet'),
  essential: (import 'flavors/essential.libsonnet'),
  lite: (import 'flavors/lite.libsonnet'),
  minimal: (import 'flavors/minimal.libsonnet'),
};

local skel = {
  local this = self,
  skip: [],
  fn:: {
    keepApps(apps)::std.filter(function(s) !std.member(this.skip, s), apps), 

  },
  on: {
    "environment-management": { files: { environments: lib.mixin } },
  }
};

function(setup) 
  skel + flavors[setup.flavor](setup)
