SWIFT_DIR=$(MK_SWIFT_DIR)
IMAGES_LIST=$(SWIFT_DIR)/images.lst

SWIFT_DEST_REGISTRY=europe-west1-docker.pkg.dev/tao-artefacts/tao-ce-poc
# SWIFT_DEST_REGISTRY=quay.io/tao-ce
SWIFT_TAG=latest
TARGET_TAG=$(SWIFT_TAG)

swift-tag:
	cat $(IMAGES_LIST) | xargs -I? nerdctl tag ?:$(SWIFT_TAG) $(SWIFT_DEST_REGISTRY)/?:$(TARGET_TAG)


swift-push:
	cat $(IMAGES_LIST) | xargs -I? nerdctl push $(SWIFT_DEST_REGISTRY)/?:$(TARGET_TAG)

swift-imagemanifests:
	 cat $(IMAGES_LIST) \
	 	| jq  \
			--arg registry ${SWIFT_DEST_REGISTRY} \
			--arg tag $(SWIFT_TAG) \
			-Rf $(SWIFT_DIR)/imagemanifests.jq \
		| yq  -p json -s '"$(SWIFT_DIR)/.cache/" + .image'

swift-manifestpush: swift-imagemanifests
	find $(SWIFT_DIR)/.cache/${SWIFT_DEST_REGISTRY} -type f \
		| xargs -n1 manifest-tool push from-spec

swift-build-devcontainer:
	# TODO buildah do not support --link 
	# podman build \

	docker build \
		-t $(SWIFT_DEST_REGISTRY)/devcontainer:$(SWIFT_TAG) \
		--build-arg DEVCONTAINER_FLAVOR=fedora \
		--target devcontainer \
		.devcontainer