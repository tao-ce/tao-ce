SWIFT_DIR=$(MK_SWIFT_DIR)
IMAGES_LIST=$(SWIFT_DIR)/images.lst

SWIFT_DEST_REGISTRY=europe-west1-docker.pkg.dev/tao-artefacts/tao-ce-poc
# SWIFT_DEST_REGISTRY=quay.io/tao-ce
SWIFT_TAG=latest


swift-tag:
	cat $(IMAGES_LIST) | xargs -I? nerdctl tag ?:$(SWIFT_TAG) $(SWIFT_DEST_REGISTRY)/?:$(SWIFT_TAG)


swift-push:
	cat $(IMAGES_LIST) | xargs -I? nerdctl push $(SWIFT_DEST_REGISTRY)/?:$(SWIFT_TAG)


swift-build-devcontainer:
	# TODO buildah do not support --link 
	# podman build \

	docker build \
		-t $(SWIFT_DEST_REGISTRY)/devcontainer:$(SWIFT_TAG) \
		--build-arg DEVCONTAINER_FLAVOR=fedora \
		--target devcontainer \
		.devcontainer