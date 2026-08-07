local lib = import '../lib.libsonnet';

function(setup)
  {
    skip+: ['proctoring'],
    on+: {
      "environment-management"+: {
        files+: {
          environments+: lib.mixin {
            patches+:: [
                function(f)
                    {environments: std.map(function(e) 
                        lib.asEnvironment(e)
                            .setFeatureFlag('monitoringEnabled', 'false')
                            .setFeatureFlag('enableProctoring', 'false')
                        ,
                        f.environments)
                    }
            ]},
          },
        }
      }
  }
