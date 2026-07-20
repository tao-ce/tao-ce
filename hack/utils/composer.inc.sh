dev_composer_prune_repositories(){
    jq -r '.repositories=[]'
}

dev_composer_stability(){
    jq 'del(.["prefer-stable"])|.["minimum-stability"] = "dev"'
}

dev_composer_registry(){
    [ -n "$2" ] || return 0
    composer repository -g add $1 composer $2
}

dev_composer_require_version() {
    jq \
      --arg dep "$1" \
      --arg ver "$2" \
       '.require[$dep] = $ver'
}

dev_composer_freeze_require_version() {
    jq \
      --arg dep "$1" \
      --arg ver "$2" \
       'if .require[$dep]
        then .require[$dep] = $ver
        else .
        end'
}

dev_composer_prefer_source_fallback() {
    jq '.config["preferred-install"]["*"] = "source-fallback"'
}
