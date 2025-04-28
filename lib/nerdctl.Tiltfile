def build(
    ref,
    context,
    build_args={},
    dockerfile=None,
    dockerfile_contents=None,
    live_update=[],
    match_in_env_vars=False,
    ignore=[],
    entrypoint=[],
    target='',
    ssh='',
    secret='',
    extra_tag='',
    cache_from=[],
    image_deps=[],
    platform='',
):

    cmd = ['nerdctl']

    cmd += ['--namespace', 'k8s.io']

    cmd += ['build']

    cmd += ['--pull=false']

    for arg, value in build_args.items():
        cmd += ['--build-arg', arg + '=' + value]

    if dockerfile:
        cmd += ['-f', dockerfile]
    elif dockerfile_contents:
        cmd += ['-f', '-']

    if target:
        cmd += ['--target', target]

    if ssh:
        cmd += ['--ssh', ssh]

    if secret:
        cmd += ['--secret', secret]

    if platform:
        cmd += ['--platform', platform]

    if extra_tag:
        if type(extra_tag) == 'string':
            cmd += ['-t', extra_tag]
        else:
            for t in extra_tag:
                cmd += ['-t', t]

    if cache_from:
        if type(cache_from) == 'string':
            cmd += ['--cache-from', cache_from]
        else:
            for v in cache_from:
                cmd += ['--cache-from', v]

    cmd = [shlex.quote(x) for x in cmd]

    cmd += ['-t', '"${EXPECTED_REF}"']
    cmd += ['-t','{}:latest'.format(ref)]

    cmd += [shlex.quote(context)]
    cmd = ' '.join(cmd)

    kwargs = {}

    custom_build(
        ref=ref,
        command=cmd,
        deps=[context],
        disable_push=True,
        skips_local_docker=True,
        live_update=live_update,
        match_in_env_vars=match_in_env_vars,
        ignore=ignore,
        entrypoint=entrypoint,
        image_deps=image_deps,
        **kwargs
    )

def pull(
    ref,
    src,
    live_update=[],
):

    cmd = ['nerdctl', '--namespace', 'k8s.io', 'pull', src]
    cmd += ['&&', 'nerdctl', '--namespace', 'k8s.io', 'image', 'tag', src, '"${EXPECTED_REF}"']
    cmd += ['&&', 'nerdctl', '--namespace', 'k8s.io', 'image', 'tag', src, '{}:latest'.format(ref)]

    cmd = ' '.join(cmd)

    kwargs = {}

    custom_build(
        ref=ref,
        command=cmd,
        deps=[],
        disable_push=True,
        skips_local_docker=True,
        live_update=live_update,
        **kwargs
    )