function(setup)
    {
        ['%(pfx)spubsub-init' % setup]: {
            PUBSUB_PROJECT_ID: setup.env.GOOGLE_CLOUD_PROJECT,
            GRPC_ARGS: '-plaintext',
            GRPC_ENDPOINT: setup.dependencies.pubsub.address.endpoint,
        },
        ['%(pfx)spubsub-init-pairs' % setup]: {
            'pairs.json': importstr 'files/pairs.json'
        },
    }