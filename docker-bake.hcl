group "default" {
    targets = ["tao-ce"]
}

variable "apps" {
    default = [
        "datastore",
        "deliver",
        "devkit",
        "dynamic-query",
        "environment-management",
        "hierarchy",
        "portal",
        "task-orchestrator",
        "timers",
        ]
}

target "_secrets" {
    secret = [
        {
            type = "file"
            id = "NPM_TOKEN"
            src = ".secrets/npm"
        }
    ]
    ssh = [ "default" ]
    network = "host"
    args = {
        BUILD_IMAGE = "build-image:latest"
        GO_BUILD_IMAGE = "go-build-image:latest"
    }
    contexts = {
        build-image  = "target:build"
        go-build-image  = "target:go-build"
    }
    target = "export"
}

target "build" {
    context = ".devcontainer"
    target = "build-fedora"
}

target "go-build" {
    context = ".devcontainer"
    dockerfile-inline = <<EOF
FROM golang:1.24-alpine
ENV CGO_ENABLED=0

RUN apk add --no-cache gcc musl-dev
EOF
}

target "deliver" {
    inherits = [ "_secrets" ]
    context = "./apps/deliver"
    contexts = {
        src-backend  = "./apps/deliver/src/be"
        src-frontend = "./apps/deliver/src/fe"
        src-sandbox  = "./apps/deliver/src/sandbox"
    }
}

target "datastore" {
    inherits = [ "_secrets" ]
    context = "./apps/datastore"
    contexts = {
        src-worker  = "./apps/datastore/src/node"
    }
}

target "devkit" {
    inherits = [ "_secrets" ]
    context = "./apps/devkit"
    contexts = {
        src-backend = "./apps/devkit/src"
    }
}

target "dynamic-query" {
    inherits = [ "_secrets" ]
    context = "./apps/dynamic-query"
    contexts = {
        src-api  = "./apps/dynamic-query/src"
    }
}

target "environment-management" {
    inherits = [ "_secrets" ]
    context = "./apps/environment-management"
    contexts = {
        src-auth-server = "./apps/environment-management/src/node-auth-server"
        src-lti-gateway = "./apps/environment-management/src/lti-gateway"
        src-sidecar     = "./apps/environment-management/src/server"
    }
}

target "hierarchy" {
    inherits = [ "_secrets" ]
    context = "./apps/hierarchy"
    contexts = {
        src-backend = "./apps/hierarchy/src"
    }
}

target "task-orchestrator" {
    inherits = [ "_secrets" ]
    context = "./apps/task-orchestrator"
    contexts = {
        src-backend = "./apps/task-orchestrator/src"
    }
}

target "portal" {
    inherits = [ "_secrets" ]
    context = "./apps/portal"
    contexts = {
        src-backend = "./apps/portal/src/backend"
        src-frontend = "./apps/portal/src/frontend"
    }
}

target "timers" {
    inherits = [ "_secrets" ]
    context = "./apps/timers"
    contexts = {
        src-backend = "./apps/timers/src"
    }
}

function "copy" {
    params = [image]
    result = join("",["COPY --from=",image," / /",image,"/"])
}

target "tao-ce" {
    context = "build/monolith"
    dockerfile-inline = <<EOF
    FROM scratch
    ${join("\n",[for a in apps : copy(a)])}
EOF

    contexts = {
        deliver = "target:deliver"
        datastore = "target:datastore"
        devkit = "target:devkit"
        dynamic-query = "target:dynamic-query"
        environment-management = "target:environment-management"
        hierarchy = "target:hierarchy"
        portal = "target:portal"
        timers = "target:timers"
        task-orchestrator = "target:task-orchestrator"
    }

    output = [
        {
            type = "local"
            dest = "/opt/tao-ce"
        }
    ]
    
}