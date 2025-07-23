.
|{
    image: ( $registry + "/" + . ),
    tags: [$tag],
    manifests: [
        {
            image: ( $registry + "/" + . + ":" + $tag + "-amd64"),
            platform: { architecture: "amd64", os: "linux" }
        },
        {
            image: ( $registry + "/" + . + ":" + $tag + "-arm64"),
            platform: {architecture: "arm64", os: "linux"}
        }
    ]
}