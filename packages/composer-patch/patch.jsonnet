function(
    src_composer,
    repos_path=".",
    )

    local packages = (import "./map.json");

    local required = std.get(src_composer, "require", {});

    local required_names = std.objectFields(required);
    local local_packages_names = std.objectFields(packages);

    local required_local = std.setInter(required_names, local_packages_names);

    {
        "composer.json":
            src_composer + {
                "minimum-stability": "dev",
                require: std.foldl(
                        function(t,x)
                            t + { [x]: packages[x].require },
                        required_local,
                        required
                    ),
                "require-dev": {},
                license: "AGPL-3.0-only OR TAO Commercial License",
                repositories: std.map(
                        function(x)
                            {
                                local version = std.get(packages[x], "version", null),
                                type: packages[x].type,
                                url: 
                                    ( if packages[x].type == "path" 
                                        then std.rstripChars(repos_path,"/") + "/"
                                        else "" ) 
                                    + packages[x].url,
                                options: 
                                    { symlink: false }
                                    + (if std.type(version) == "null"
                                        then {}
                                        else { versions: { [x]: version } }),
                            },
                        local_packages_names
                        // required_local
                    ),
            }
    }