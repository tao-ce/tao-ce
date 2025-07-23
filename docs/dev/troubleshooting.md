
## General cases

### My computer is running out of diskspace since I start running this stack

`buildkit` and `containerd` might be very greedy on resources (>50GB), especially when you run several build in a short lapse of time (Garbage collection keep artifacts for few hours in cache, you may configure a shorter grace period `imageMinimumGCAge` in `k3s` configuration).

You may run the following command from `dev` container to free up some space:
```
dev$ buildctl prune --all
dev$ nerdctl system prune --all
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

### Composer is complaining about missing tag

```
#12 23.04   [RuntimeException]                                                                                                                                          
#12 23.04   Failed to execute git checkout '862700068db0ddfd8c5b850671e029a90246ec75' -- && git reset --hard '862700068db0ddfd8c5b850671e029a90246ec75' --              
#12 23.04                                                                                                                                                               
#12 23.04   fatal: reference is not a tree: 862700068db0ddfd8c5b850671e029a90246ec75                                                                                    
#12 23.04                                                                                                                                                               
#12 23.04   It looks like the commit hash is not available in the repository, maybe the tag was recreated? Run "composer update symfony/var-exporter" to resolve this.  
```

There might be some inconsistent cache in `buildkitd`; you may purge it with the following command from `dev`.

```
dev$ buildctl prune --all
```
