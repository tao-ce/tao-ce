state_data() {
    rm -rf $2
    mkdir -p $STATE_ROOT/$1
    ln -s $STATE_ROOT/$1 $2
}

dev_git_cleanup(){
    {
        find $1 -type d | grep '[/][.]git$' || true
        find $1 -type f | grep '[/][.]git.*$' || true
        ls -d $1/test/ || true
        ls -d $1/*/views/js/{test,tests} || true
        ls -d $1/*/views/cypress || true
        ls -d $1/vendor/*/*/{test,tests,test_files} || true
    } 2>/dev/null | xargs rm -rf
}
