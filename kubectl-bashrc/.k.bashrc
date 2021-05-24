# Put in $HOME
# echo ". $HOME/.k.bashrc" >> $HOME/.bashrc

source <(kubectl completion bash)

alias k=kubectl
complete -F __start_kubectl k

#Set a permanent namespace
kns() {
   kubectl config set-context --current --namespace=$1
}

dry="--dry-run=client"

alias kctx='kubectl config current-context'

alias kdes='kubectl describe'
alias kdesc='kubectl describe'

alias kev='kubectl get events'

alias kpod='kubectl get pods'
alias kpods='kubectl get pods'

alias ksvc='kubectl get services'
alias ksrv='kubectl get services'

alias kdep='kubectl get deployments'
alias kdepl='kubectl get deployments'

alias klogs='kubectl logs -f'

alias kall='kubectl get all --all-namespaces'

alias kdump='kubectl cluster-info dump'
alias kinfo="kubectl cluster-info"

alias kapply='kubectl apply -f'

alias krestart='kubectl rollout restart deployment '
