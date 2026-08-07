local lib = import '../lib.libsonnet';

function(setup)
  {
    skip+: ['construct'],
    on+: {
      "environment-management"+: {
        files+: {
          environments+: lib.mixin {
            patches+:: [
                function(f)
                    {environments: std.map(function(e) 
                        lib.asEnvironment(e)
                            .updateRoles(function(r)
                                lib.asRole(r)
                                    .removePermission('portal.content-bank')
                                    .setRestriction('portal.content-bank', ['view','all'])
                                )
                        ,
                        f.environments)
                    }
            ]},
          },
        }
      }
  }