

# `tao-ce` repository

## Repository structure

### [`apps`](/apps)

Each applications in apps contains:
* a `src` folder containing sources and/or submodules pointing to sources
* a `Dockerfile` to build each application
* a `meta` folder
  - a `systemd` directory containing services units to be deployed

### [`build`](/build)

This folder contains building toolchain for each product, and their dependencies:
* [`crystal`](/build/crystal/): the local deployment from sources 
* [`swift`](/build/swift/): the deployment through pre-built container

### [`hack`](/hack)

This folder contains some quick-win used in development. They should be removed soon or later and replaced by more suitable solution.

### [`services`](/services/)

Some external dependencies need to be built and run in order to have TAO Community working.

### [`.devcontainer`](/.devcontainer/)

This container is used for active development to run all essential services.

### [`etc`](/etc) and [`libexec`](/libexec)

Configuration and resources to be used for image building.

* [`systemd`](/libexec/systemd/): common units for setup and static resources.
* [`setup`](/libexec/setup): some `jsonnet` templates to generate applications config.
* [`init`](/libexec/init/): initialization data.
* [`pubsub`](/libexec/pubsub/): Python script to provision PubSub topics and subscriptions.


## `Taskfile` workflow

[go-task](https://taskfile.dev/docs/guide) is used to organize appliation build and local deployement of the TAO Community ecosystem in devcontainer.


Once in `devcontainer` environment, running `task dev:up` will build all dependencies and start local application deployment.
