
CONTAINERD_NAMESPACE = os.getenv('CONTAINERD_NAMESPACE', default='k8s.io')


def build_cmd(
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
    push_dests=['europe-west1-docker.pkg.dev/tao-artefacts/tao-ce-poc'],
    ns=CONTAINERD_NAMESPACE,
):

    cmd = ['nerdctl',
        '--namespace', ns,
        'build',
        '--pull=false',]

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

    return cmd

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
    ns=CONTAINERD_NAMESPACE,
    src=None,
):

    cmd = ['nerdctl',
        '--namespace', ns,
        'build',
        '--pull=false',]

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
    src=None,
    context=None,
    dockerfile=None,
    target=None,
    build_args=None,
    live_update=[],
    ns=CONTAINERD_NAMESPACE,
):

    if not src:
        warn("unsupported pull for {}. Missing src.".format(ref))
        return

    cmd = ['nerdctl', '--namespace', ns, 'pull', src]
    cmd += ['&&', 'nerdctl', '--namespace', ns, 'image', 'tag', src, '"${EXPECTED_REF}"']
    cmd += ['&&', 'nerdctl', '--namespace', ns, 'image', 'tag', src, '{}:latest'.format(ref)]

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
