function(
    src_package={},
    repos_map=(import "./map.json"),
    packages_path=".",
    app_path="",
    )

    local required = std.get(src_package, "dependencies", {});

    local required_names = std.objectFields(required);
    local local_packages_names = std.objectFields(repos_map);

    local required_local = std.setInter(required_names, local_packages_names);

    local packagePath(x) = std.rstripChars(
            if repos_map[x].package == app_path
            then repos_map[x].path
            else "%s/%s/%s" % [
                packages_path,
                repos_map[x].package,
                repos_map[x].path,
            ], "/");

    {
        "package.json": std.manifestJson(
            src_package + {

                dependencies: std.foldl(
                        function(t,x)
                            t + { [x]: "file:%s" % packagePath(x)},
                        required_local,
                        required
                    ),
                
                // workspaces+: std.map(packagePath, local_packages_names,),

                // overrides+: std.foldl(
                //         function(t,x)
                //             t + if std.get(src_package,'name','') == x
                //             then {}
                //             else { [x]: 
                //                 if std.member(required_local, x)
                //                 then "$%s" % x
                //                 else "file:%s" % packagePath(x)
                //             },
                //         local_packages_names,
                //         std.get(src_package, 'overrides', {})
                //     ),

                license: "AGPL-3.0-only OR TAO Commercial License",
            }),
        ".required_local.lst":
            std.join("\n", required_local),
        ".local_packages.lst":
            std.join("\n", std.map(packagePath, local_packages_names)),
    }