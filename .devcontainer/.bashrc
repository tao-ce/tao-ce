

alias k=kubectl
alias kaf="kubectl apply -f"
alias kak="kubectl apply -k"
alias kn="kubectl ns"
alias kx="kubectl ctx"
alias kd="kubectl describe"
alias ke="kubectl explain"
alias kg="kubectl get"
alias krr="kubectl rollout restart"
alias kvpn="kubectl kubevpn"

alias dc="docker-compose"

echo "Current kubectl context: " $(kubectl config current-context || true) >&2



