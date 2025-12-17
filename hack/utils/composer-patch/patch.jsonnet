function(
    src_composer={},
    repos_map=(import "./map.json"),
    repos_ban=(import "./ban.json"),
    packages_path=".",
    )

    local required = std.get(src_composer, "require", {});
    
    local ban = std.mergePatch({require: [], replace: []}, repos_ban);

    local required_names = std.objectFields(required);
    local local_packages_names = std.objectFields(repos_map);

    local required_local = std.setInter(required_names, local_packages_names);

    {
        "composer.json": std.manifestJson(
            src_composer + {
                "minimum-stability": "dev",
                require: std.foldl(
                        function(t,x)
                            t + { [x]: repos_map[x].require },
                        required_local,
                        required
                    ),
                replace+: {},
                // "require-dev": {},
                license: "AGPL-3.0-only OR TAO Commercial License",
                repositories: std.map(
                        function(x)
                            {
                                local version = std.get(repos_map[x], "version", null),
                                type: repos_map[x].type,
                                url: 
                                    ( if repos_map[x].type == "path" 
                                        then std.rstripChars(packages_path,"/") + "/"
                                        else "" ) 
                                    + repos_map[x].url,
                                options: 
                                    { symlink: false }
                                    + (if std.type(version) == "null"
                                        then {}
                                        else { versions: { [x]: version } }),
                            },
                        local_packages_names
                    ),
            } + {
                require: std.prune(super.require + std.foldl(function(t,x) {[x]: null}, ban.require, {})),
                replace: std.prune(super.replace + std.foldl(function(t,x) {[x]: null}, ban.replace, {})),
            }),
        ".required_local.lst":
            std.join("\n", required_local),
    }