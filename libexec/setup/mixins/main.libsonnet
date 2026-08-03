local lib = import 'lib.libsonnet';

local flavors = {
  full: (import 'flavors/full.libsonnet'),
  essential: (import 'flavors/essential.libsonnet'),
  lite: (import 'flavors/lite.libsonnet'),
  minimal: (import 'flavors/minimal.libsonnet'),
};

local skel = {
  on: {
    "environment-management": { files: { environments: lib.mixin } },
  }
};

function(setup) 
  skel + flavors[setup.flavor](setup)
