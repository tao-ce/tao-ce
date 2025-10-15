

which task 2>/dev/null >/dev/null || {
    which go-task 2>/dev/null >/dev/null && alias task="$(which go-task)" || cat <<EOF
        WARNING: Cannot find task tool
EOF
}
