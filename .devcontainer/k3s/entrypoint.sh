#!/bin/ash
#

# KUBE_DIR=$(dirname ${K3S_KUBECONFIG_OUTPUT})

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


# {

#     until test -f ${K3S_KUBECONFIG_OUTPUT} ; do
#         echo waiting ${K3S_KUBECONFIG_OUTPUT}
#         sleep 1
#     done

#     sed -e "s@server:.*@server: https://k8s:6443@" ${K3S_KUBECONFIG_OUTPUT} >$KUBE_DIR/config
#     rm -f ${K3S_KUBECONFIG_OUTPUT}
# } &

exec /bin/k3s $@