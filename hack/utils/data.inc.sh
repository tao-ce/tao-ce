state_data() {
    rm -rf $2
    mkdir -p $STATE_ROOT/$1
    ln -s $STATE_ROOT/$1 $2
}

dev_git_cleanup(){
    {
        find $1 -type d | grep '[/][.]git$'
        find $1 -type f | grep '[/][.]git.*$'
    } | xargs rm -rf
}