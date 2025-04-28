
_fail() {
    echo "[$app_fid] FAIL " $@ >&2
    exit 50
}

_warn() {
    echo "[$app_fid] WARN " $@ >&2
}

_info() {
    echo "[$app_fid] INFO " $@ >&2
}

_sem() {
    date -u +%s >"$1"
}
