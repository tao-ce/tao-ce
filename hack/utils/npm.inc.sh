
npm() {
    /usr/local/libexec/nvm/nvm-exec npm $@
}

npx() {
    /usr/local/libexec/nvm/nvm-exec npx $@
}

node() {
    /usr/local/libexec/nvm/nvm-exec node $@
}

dev_npm_registry(){
    [ -n "$1" ] || return 0
    yes "verdaccio" | npm login --registry $1 --auth-type legacy
    npm config set registry=$1
}

dev_npm_freeze_dependency_version() {
    jq \
      --arg dep $1 \
      --arg ver $2 \
       'if .dependencies[$dep]
        then .dependencies[$dep] = $ver
        else .
        end'
}