allow_k8s_contexts('default')
load('ext://uibutton', 'cmd_button', 'text_input', 'location', 'choice_input', 'bool_input')
secret_settings ( disable_scrub = True ) 

NAME_BY = "tier"
WORKLOADS = ["Deployment", "StatefulSet", "CronJob", "DaemonSet"]

BASE_IMAGE_POLICY = os.getenv('BASE_IMAGE_POLICY', default='pull')
SERVICE_IMAGE_POLICY = os.getenv('SERVICE_IMAGE_POLICY', default='build') # pull not yet supported

DEFAULT_DEST_REGISTY = 'europe-west1-docker.pkg.dev/tao-artefacts/tao-ce-poc'
DEFAULT_PROFILE = 'minimal'


APPS = read_json('./apps.json')

PROFILES = {
    "all": APPS.keys(),
    "core": ["setup", "construct"],
    "minimal": ["setup", "environment-management", "portal"],
    "env": os.getenv('APPS', APPS.keys()),
    "but": list(set(APPS.keys()) - set(os.getenv('APPS', '').split(','))),
}

config.define_string('profile')
config.define_string('local-build')
config.define_bool('from-scratch')
config.define_bool('push')
config.define_bool('no-deploy')
config.define_string('dest-registry')
cfg=config.parse()

cfg_local_build=cfg.get("local-build", '').split(',')
cfg_from_scratch=cfg.get("from-scratch", False)
cfg_no_deploy=cfg.get("no-deploy", False)
cfg_dest_registry = cfg.get('dest-registry', DEFAULT_DEST_REGISTY)
cfg_push=cfg.get("push", False)

print("localbuild", cfg_local_build)

apps = PROFILES[cfg.get('profile', DEFAULT_PROFILE)]

builder = load_dynamic('./lib/nerdctl.Tiltfile')

buildenv = load_dynamic('./build/Tiltfile')
buildenv['images'](builder=builder[BASE_IMAGE_POLICY])

services = load_dynamic('./services/Tiltfile')
services['images'](builder=builder[SERVICE_IMAGE_POLICY])

for app in apps:
    a = load_dynamic('{}/Tiltfile'.format(APPS[app]))
    
    if cfg_from_scratch or app in cfg_local_build:
        a['images'](builder=builder['build'])
        ay = a['manifest']()

    else:
        ay = kustomize('manifests/{app}'.format(app=app))

    if not cfg_no_deploy:
        for ko in decode_yaml_stream(ay):
            if ko["kind"] in WORKLOADS:
                links = [x for x in [ko["metadata"].get("annotations",{}).get("tilt.dev/resource-link","")] if x]

                k8s_resource(
                    ko["metadata"]["name"],
                    labels=[app],
                    new_name='{}-{}'.format(
                        app,
                        ko["metadata"].get("labels",{}).get(NAME_BY,"unknown")
                    ),
                    links=links
                    )

        a.get('ui', lambda: None)()

        k8s_yaml(ay)

local_resource('k8s events', serve_cmd="kubectl events -Aw", labels=["cluster"], auto_init=False)



cmd_button(
    name='local-builds',
    text='Enable local build',
    location=location.NAV,
    argv=["/bin/sh", "-c", '''
    tilt args -- --local-build {} --profile {}
    '''.format(
        ",".join(['"$LB_{}"'.format(a.replace('-','_')) for a in apps]),
        cfg.get('profile', DEFAULT_PROFILE),
    )],
    icon_name='install_desktop',
    inputs=[
        bool_input('LB_{}'.format(a.replace('-',"_")), a, default=False,true_string=a,false_string="")
        for a in apps
    ],
)

cmd_button(
    name='profile',
    text='Switch profile',
    icon_name='switch_account',
    location=location.NAV,
    argv=["/bin/sh", "-c", 'tilt args -- --profile "$profile"'],
    inputs=[
        choice_input("profile", "Profile", list(PROFILES.keys())),
    ],
)