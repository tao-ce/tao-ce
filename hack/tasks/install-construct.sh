#!/bin/sh
#

kubectl exec -c backend -it sts/tao-ce-tao -- taoadm install -F
kubectl rollout restart sts/tao-ce-tao
