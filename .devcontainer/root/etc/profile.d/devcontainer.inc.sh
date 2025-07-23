alias k=kubectl
alias kaf="kubectl apply -f"
alias kak="kubectl apply -k"
alias kn="kubectl ns"
alias kx="kubectl ctx"
alias kd="kubectl describe"
alias ke="kubectl explain"
alias km="kubectl edit"
alias kg="kubectl get"
alias krr="kubectl rollout restart"
alias krc="kubectl run krc-$(date +%y%m%d-%H%M%S) --restart=Never --command --rm -it"
alias docker=nerdctl

echo "Current kubectl context: " $(kubectl config current-context || true) >&2
