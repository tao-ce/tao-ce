
## General cases

### My computer is running out of diskspace since I start running this stack

You may run the following command from `dev` container to free up some space:
```
dev$ podman prune --all
dev$ podman system prune --all
```

Eventually, cleanup some local host resources from docker storage, with:

```
host$ docker prune
```

## During build process

### Composer/NPM/... are complaining about denied permission while accessing a Github repository

As most of our repositories are currently private, you need to grant building jobs to access them through SSH agent.

Any key added to your local host `ssh-agent` can be used in `dev` container.

Ensure to run the following command to add your key to agent:

```
host$ ssh-add /path/to/your/ssh/private.key
```

You can check what are current key available in `dev` container with:
```
dev$ ssh-add -l
```
