
```mermaid
flowchart TB
    subgraph dependencies
        direction TB
        pubsub
        elasticsearch
        firestore
        redis
        postgres
    end
    %% subgraph systemd
        %% direction TB
        %% cockpit
        %% podman
    %% end
    subgraph K8S
        direction BT
        istio
        cert-manager
        setup
    end
    subgraph TAO
        direction BT
        em[environment-management]
        portal[\portal/]
        construct[\construct/]
        devkit[\devkit/]
        deliver --- devkit
        deliver --- construct 
        em --- timers --- deliver 
        em --- datastore --- deliver --- portal
        datastore --- scoring --- portal
        em --- hierarchy ---- portal 
        em --- dynamic-query ---- portal
        em --- task-orchstrator ---- portal
        
    end
    TAO --- K8S --- dependencies
```