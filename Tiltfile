allow_k8s_contexts('default')
load('ext://uibutton', 'cmd_button', 'text_input', 'location', 'choice_input', 'bool_input')
secret_settings ( disable_scrub = True ) 

NAME_BY = "tier"
WORKLOADS = ["Deployment", "StatefulSet", "CronJob", "DaemonSet"]

BASE_IMAGE_POLICY = os.getenv('BASE_IMAGE_POLICY', default='pull')
SERVICE_IMAGE_POLICY = os.getenv('SERVICE_IMAGE_POLICY', default='build') # pull not yet supported

APPS = read_json('./apps.json')

PROFILES = {
    "all": APPS.keys(),
    "core": ["construct"],
    "minimal": ["environment-management", "portal"],
    "env": os.getenv('APPS', APPS.keys()),
    "but": list(set(APPS.keys()) - set(os.getenv('APPS', '').split(','))),
}


config.define_string('profile')
config.define_string('local-build')

# apps = PROFILES[os.getenv('TILT_PROFILE', 'all')]
# config.define_string_list('local-build', args=True)

cfg=config.parse()
cfg_local_build=cfg.get("local-build", '').split(',')

print("localbuild", cfg_local_build)


apps = PROFILES[cfg.get('profile', 'all')]

builder = load_dynamic('./lib/nerdctl.Tiltfile')

buildenv = load_dynamic('./build/Tiltfile')
buildenv[BASE_IMAGE_POLICY](builder=builder)

services = load_dynamic('./services/Tiltfile')
services[SERVICE_IMAGE_POLICY]( builder=builder)

for app in apps:
    a = load_dynamic('{}/Tiltfile'.format(APPS[app]))
    
    if app in cfg_local_build:
        a['build'](builder=builder)
        ay = a['manifest']()
    else:
        ay = kustomize('manifests/{app}'.format(app=app))

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
    argv=["/bin/sh", "-c", 'tilt args -- --local-build {} --profile {}'.format(
        ",".join(['"$LB_{}"'.format(a.replace('-','_')) for a in apps]),
        cfg.get('profile', 'all'),
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