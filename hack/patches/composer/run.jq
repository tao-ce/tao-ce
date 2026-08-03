def add_require(dep; ver): .require[dep] = ver;
def drop_require(ver): del(.require[ver]);
def replace_version(dep; ver): if .require[dep] then add_require(dep; ver) else . end;
def prune_repositories: .repositories=[];
def stability(s): del(.["prefer-stable"])|.["minimum-stability"] = s;
def preferred_install(p): .config["preferred-install"] = p;

. 
    | prune_repositories
    | stability("dev")
    | preferred_install("source-fallback")
    | reduce ($patches[0].drop[]) as $p (. ; drop_require($p))
    | reduce ($patches[0].replace|to_entries[]) as $p (.; . | replace_version($p.key; $p.value))
    | reduce ($patches[0].add|to_entries[]) as $p (.; . | add_require($p.key; $p.value))
