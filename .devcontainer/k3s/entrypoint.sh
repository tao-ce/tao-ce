#!/bin/ash
#

{
    
    until crictl info ; do 
        echo waiting containerd...
        sleep 1 
    done

    while sleep 1 ; do
        /bin/buildkitd \
            --config /opt/k3s/conf/buildkitd.toml
    done
} &

exec /bin/k3s $@ --prefer-bundled-bin 