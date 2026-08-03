local lib = import '../lib.libsonnet';

function(setup)
  {
    on+: {
      "environment-management"+: {
        files+: {
          environments+: lib.mixin {
            patches+:: [
                function(f)
                    {environments: std.map(function(e) 
                        lib.asEnvironment(e)
                        .setFeatureFlag('SCORING_SUBMISSION_ENABLED', 'false')
                        .setFeatureFlag('SCORING_OWNS_GRADING_PROGRESS', 'false')
                        .setFeatureFlag('gradingEnabled', 'false')
                        ,
                        f.environments)
                    }
            ]},
          },
        }
      }
  }
