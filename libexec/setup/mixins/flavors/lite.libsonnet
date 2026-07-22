function(setup)
    (import './essential.libsonnet')(setup)
    + (import '../features/disable_backoffice.libsonnet')(setup)
    