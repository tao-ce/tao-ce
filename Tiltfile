allow_k8s_contexts('default')
load('ext://uibutton', 'cmd_button', 'text_input', 'location')
secret_settings ( disable_scrub = True ) 

builder = load_dynamic('./lib/nerdctl.Tiltfile')
buildenv = load_dynamic('./build/Tiltfile')

buildenv['php'](builder=builder)

services = load_dynamic('./services/Tiltfile')
services['build'](
    builder=builder,
)

tao_construct = load_dynamic('./apps/construct/Tiltfile')
tao_construct['build'](
    builder=builder,
    # pulls={'frontend': 'library/nginx:latest'}
    )

tao_dynamic_query= load_dynamic('./apps/dynamic-query/Tiltfile')
tao_dynamic_query['build'](
    builder=builder,
)

tao_timers= load_dynamic('./apps/timers/Tiltfile')
tao_timers['build'](
    builder=builder,
)

tao_portal= load_dynamic('./apps/portal/Tiltfile')
tao_portal['build'](
    builder=builder,
)

tao_devkit = load_dynamic('./apps/devkit/Tiltfile')
tao_devkit['build'](
    builder=builder,
)

tao_em = load_dynamic('./apps/environment-management/Tiltfile')
tao_em['build'](
    builder=builder,
)

tao_deliver = load_dynamic('./apps/deliver/Tiltfile')
tao_deliver['build'](
    builder=builder,
)

tao_simple_reports = load_dynamic('./apps/simple-reports/Tiltfile')
tao_simple_reports['build'](
    builder=builder,
)

tao_task_orchestrator = load_dynamic('./apps/task-orchestrator/Tiltfile')
tao_task_orchestrator['build'](
    builder=builder,
)

tao_datastore = load_dynamic('./apps/datastore/Tiltfile')
tao_datastore['build'](
    builder=builder,
)

tao_hierarchy = load_dynamic('./apps/hierarchy/Tiltfile')
tao_hierarchy['build'](
    builder=builder,
)

tao_scoring = load_dynamic('./apps/scoring/Tiltfile')
tao_scoring['build'](
    builder=builder,
)