group "default" {
    targets = concat(["devcontainer"], apps)
    #targets = images
}

group "all" {
    targets = concat(apps, images)
}


variable "registry" {
    default = "localhost/tao-ce"
}

variable "images" {
    default = [
        "tao-ce",
        "monolith",
    ]
}

variable "apps" {
    default = [
        "construct",
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

variable "TAG" {
    default = "tao-ce-release-candidate-01"
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
    output = [
        {
            type = "docker"
            #type = "image"
            #oci-mediatypes = true
            name-canonical = true
            push = false
        }
    ]
    target = "export"
#    attest = [
#        {
#            type = "provenance"
#            mode = "max"
#        },
#        {
#          type = "sbom"
#        }
#    ]
}

target "build" {
    context = ".devcontainer"
    target = "build-fedora"
}

target "devcontainer" {
    context = ".devcontainer"
    target = "devcontainer"

    output = [
        {
            type = "image"
            oci-mediatypes = true
            name-canonical = true
            push = false
        }
    ]

    tags = ["localhost/tao-ce/devcontainer:latest"]
}

target "go-build" {
    context = ".devcontainer"
    dockerfile-inline = <<EOF
FROM golang:1.24-alpine
ENV CGO_ENABLED=0

RUN apk add --no-cache gcc musl-dev
EOF
}

target "construct" {
    inherits = [ "_secrets" ]
    context = "./apps/construct"
    contexts = {
        src-code = "./apps/construct/src"
    }
    tags = tags("construct")
}

target "deliver" {
    inherits = [ "_secrets" ]
    context = "./apps/deliver"
    contexts = {
        src-backend  = "./apps/deliver/src/be"
        src-frontend = "./apps/deliver/src/fe"
        src-sandbox  = "./apps/deliver/src/sandbox"
    }
    tags = tags("deliver")
}

target "datastore" {
    inherits = [ "_secrets" ]
    context = "./apps/datastore"
    contexts = {
        src-worker  = "./apps/datastore/src/node"
    }
    tags = tags("datastore")
}

target "devkit" {
    inherits = [ "_secrets" ]
    context = "./apps/devkit"
    contexts = {
        src-backend = "./apps/devkit/src"
    }
    tags = tags("devkit")
}

target "dynamic-query" {
    inherits = [ "_secrets" ]
    context = "./apps/dynamic-query"
    contexts = {
        src-api  = "./apps/dynamic-query/src"
    }
    tags = tags("dynamic-query")
}

target "environment-management" {
    inherits = [ "_secrets" ]
    context = "./apps/environment-management"
    contexts = {
        src-auth-server = "./apps/environment-management/src/node-auth-server"
        src-lti-gateway = "./apps/environment-management/src/lti-gateway"
        src-sidecar     = "./apps/environment-management/src/server"
    }
    tags = tags("environment-management")
}

target "hierarchy" {
    inherits = [ "_secrets" ]
    context = "./apps/hierarchy"
    contexts = {
        src-backend = "./apps/hierarchy/src"
    }
    tags = tags("hierarchy")
}

target "task-orchestrator" {
    inherits = [ "_secrets" ]
    context = "./apps/task-orchestrator"
    contexts = {
        src-backend = "./apps/task-orchestrator/src"
    }
    tags = tags("task-orchestrator")
}

target "portal" {
    inherits = [ "_secrets" ]
    context = "./apps/portal"
    contexts = {
        src-backend = "./apps/portal/src/backend"
        src-frontend = "./apps/portal/src/frontend"
    }
    tags = tags("portal")
}

target "timers" {
    inherits = [ "_secrets" ]
    context = "./apps/timers"
    contexts = {
        src-backend = "./apps/timers/src"
    }
    tags = tags("timers")
}

function "copy" {
    params = [image]
    result = join("",["COPY --link --from=",image," / /",image,"/"])
}

function "tags" {
    params = [name]
    result = [join("",["tao-ce/payload/",name,":",TAG])]
}

target "tao-ce" {
    context = "build/monolith"
    dockerfile-inline = <<EOF
    FROM scratch
    ${join("\n",[for a in apps : copy(a)])}
EOF


    contexts = {
        construct = "target:construct"
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

    tags = ["${registry}/code:latest"]
}


target "monolith" {
    context = "."
    contexts = {
  #      tao-ce = "target:tao-ce"
        base = "target:devcontainer"
    }
    output = [
        {
            type = "image"
            oci-mediatypes = true
            name-canonical = true
            push = false
        }
    ]
    tags = ["${registry}/monolith:latest"]
}
