analytics_settings(False)
update_settings(max_parallel_updates=6)

PWD = os.getcwd()

BUILD_SIGNALS_DIR=os.getenv('BUILD_SIGNALS_DIR', default=".cache/tilt/signals")
BUILD_REG="localhost"
BUILD_TAG="tilt-dev"

BUILD_ORG="tao-ce"

DEPLOY_ROOT="/opt/tao-ce"

BUILD_COMMON_FLAGS=[
    "--ssh default",
    "--secret type=file,id=NPM_TOKEN,src={pwd}/.secrets/npm".format(pwd=PWD),
]

def target(name, path, body):
    return struct(name=name, path=path, **body)
    
APPS = [
    target("construct", "./apps/construct", {
        "build": {
            "context": ".",
            "contexts": {
                "src-code": "./src"
            },
            "target": "export"
        },
    }),
    target("datastore", "./apps/datastore", {
        "build": {
            "context": ".",
            "contexts": {
                "src-worker": "./src/node"
            },
            "target": "export"
        },
    }),
    target("deliver", "./apps/deliver", {
        "build": {
            "context": ".",
            "contexts": {
                "src-backend": "./src/be",
                "src-frontend": "./src/fe",
                "src-sandbox": "./src/sandbox",
            },
            "target": "export"
        },
    }),
    target("devkit", "./apps/devkit", {
        "build": {
            "context": ".",
            "contexts": {
                "src-backend": "./src"
            },
            "target": "export"
        },
    }),
    target("environment-management", "./apps/environment-management", {
        "build": {
            "context": ".",
            "contexts": {
                "src-auth-server": "./src/node-auth-server",
                "src-lti-gateway": "./src/lti-gateway",
                "src-sidecar": "./src/server",
            },
            "target": "export"
        },
    }),
    target("dynamic-query", "./apps/dynamic-query", {
        "build": {
            "context": ".",
            "contexts": {
                "src-api": "./src"
            },
            "target": "export"
        },
    }),
    target("hierarchy", "./apps/hierarchy", {
        "build": {
            "context": ".",
            "contexts": {
                "src-backend": "./src"
            },
            "target": "export"
        },
    }),
    target("task-orchestrator", "./apps/task-orchestrator", {
        "build": {
            "context": ".",
            "contexts": {
                "src-backend": "./src"
            },
            "target": "export"
        },
    }),
    target("portal", "./apps/portal", {
        "build": {
            "context": ".",
            "contexts": {
                "src-backend": "./src/backend",
                "src-frontend": "./src/frontend",
            },
            "target": "export"
        },
    }),
    target("timers", "./apps/timers", {
        "build": {
            "context": ".",
            "contexts": {
                "src-backend": "./src"
            },
            "target": "export"
        },
    }),
]

buildah = struct(**load_dynamic('lib/Tiltfile.buildah'))

def local_image_name(name,tag=BUILD_TAG):
    return "{reg}/{org}/{name}".format(
        name=name,
        reg=BUILD_REG,
        org=BUILD_ORG,
        ) + (":{tag}".format(tag=tag) if tag else "")


build_images = {
    "build-base": local_image_name('build/base'),
    "build-go": local_image_name('build/go'),
}

build_args = {
    "BUILD_IMAGE": build_images["build-base"],
    "GO_BUILD_IMAGE": build_images["build-go"],
}

buildah.local_build(
    name="build-go",
    tags=[ build_images["build-go"] ],
    target="build-go",
    labels=["build"],
)

buildah.local_build(
    name="build-base",
    tags=[ build_images["build-base"] ],
    target="build-base",
    labels=["build"],
)



for app in APPS:

    build = struct(**getattr(app,"build",{}))

    cmd_deploy = [
        "set -eux",
        "sudo systemctl daemon-reload", 
        "sudo systemctl enable meta/systemd/*.service",
        "sudo systemctl restart --all tao-ce.{}*".format(app.name),
        "journalctl -fu tao-ce.{}*".format(app.name),
    ]

    print(cmd_deploy)

    buildah.local_app(
        name=app.name,
        dir=app.path,
        additional_flags=BUILD_COMMON_FLAGS,
        # deps=["{}/{}".format(app.path, build.context)],
        args=build_args,
        serve_cmd="\n".join(cmd_deploy),
        after_build=build_images.keys(),
        tags=[local_image_name(app.name)],
        labels=[app.name],
        **app.build,
    )


# ("app-{}".format(a.name)): local_image_name(a.name) for a in APPS}

buildah.local_build(
    name="tao-ce",
    auto_init=False,
    tags=[local_image_name("code/tao-ce")],
    labels=["build"],
    inline_file="""
FROM scratch

{copy_apps}

""".format(copy_apps="\n".join(["COPY --link --from=app-{app} / /{app}".format(app=a.name) for a in APPS])),
    contexts={("app-{}".format(a.name)): "container-image://"+local_image_name(a.name) for a in APPS},
)

buildah.local_build(
    name="monolith",
    auto_init=False,
    tags=[local_image_name("monolith")],
    target="monolith",
    contexts={"tao-ce": "container-image://"+local_image_name("code/tao-ce") },
    labels=["build"],
)


local_resource("setup", cmd="""
set -eux
sudo cp -va ./etc/* /etc/
sudo cp -va ./libexec/* /usr/local/libexec/tao-ce/
""",
serve_cmd="""
set -eux
sudo systemctl daemon-reload
sudo systemctl enable ./libexec/systemd/tao-ce.target
sudo systemctl enable ./libexec/systemd/tao-ce.setup.service
sudo systemctl enable ./libexec/systemd/tao-ce.static.service
sudo systemctl restart tao-ce.setup.service &
sudo systemctl restart tao-ce.static.service &
journalctl -xfu tao-ce.setup.service &
journalctl -xfu tao-ce.static.service
""", deps=["./etc", "./libexec"])