
COZY_CACHE_DIR=$(MK_COZY_DIR)/.cache
COZY_CONFIG_DIR=$(MK_COZY_DIR)/config
COZY_OUTPUT_DIR=$(COZY_CACHE_DIR)/output
COZY_CONTEXT_DIR=$(MK_COZY_DIR)

COZY_CA_DIR=$(TLS_PATH)
COZY_TASKS_DIR=$(MK_ROOT)/hack/tasks
COZY_ASSETS_DIR=$(MK_ROOT)/assets/tests

COZY_MANIFESTS_DIR=$(COZY_CACHE_DIR)/manifests
COZY_BOOTC_CONTAINER=localhost/ossvm:latest

COZY_TESTVM_NAME=tao-ce-cozy
COZY_TESTVM_BASE=$(COZY_OUTPUT_DIR)/qcow2/disk.qcow2
COZY_TESTVM_SNAP=$(COZY_OUTPUT_DIR)/qcow2/run.qcow2

POC_GAR_KEY=$(MK_COZY_DIR)/../poc-registry/gar-reader-key.json

TAO_DOMAIN=community.tao.internal

include $(MK_COZY_DIR)/cozy-tls.mk
include $(MK_COZY_DIR)/cozy-poc.mk
include $(MK_COZY_DIR)/cozy-vbox.mk

cozy-prepare:
	mkdir -p \
		$(COZY_MANIFESTS_DIR)

cozy-manifests: cozy-prepare $(COZY_CACHE_DIR)/.dockerconfigjson
	kubectl kustomize \
		$(MK_COZY_DIR) \
			>$(COZY_MANIFESTS_DIR)/tao-community-edition-cozy.yml 

cozy-certs: $(COZY_COCKPIT_CERT_DIR)/server.crt
	cp \
		$(COZY_CA_DIR)/ca.crt \
		$(COZY_CA_DIR)/ca.key \
			$(COZY_TLS_DIR)/
	cp \
		$(COZY_CA_DIR)/ca.crt \
			$(COZY_COCKPIT_CERT_DIR)/

cozy-assets:
	mkdir -p $(COZY_CACHE_DIR)/assets/
	cp  -a \
		$(COZY_ASSETS_DIR)/* \
		$(COZY_CACHE_DIR)/assets/

cozy-tasks:
	mkdir -p $(COZY_CACHE_DIR)/tasks/
	cp  -a \
		$(COZY_TASKS_DIR)/* \
		$(COZY_CACHE_DIR)/tasks/

cozy-container: cozy-manifests cozy-certs cozy-tasks cozy-assets
	sudo podman build \
		--no-hosts \
		--no-hostname \
		--security-opt label=type:unconfined_t \
		--build-arg=TAO_DOMAIN=$(TAO_DOMAIN) \
		-t $(COZY_BOOTC_CONTAINER) \
		$(COZY_CONTEXT_DIR)

cozy-runc:
	sudo podman run \
		--rm \
		-it \
		$(COZY_BOOTC_CONTAINER) \
		/bin/sh

cozy-vm-img: cozy-prepare
	sudo podman run \
		--rm \
		-it \
		--privileged \
		--pull=newer \
		--security-opt label=type:unconfined_t \
		-v $(COZY_CONFIG_DIR)/bootc.toml:/config.toml:ro \
		-v $(COZY_OUTPUT_DIR):/output \
		-v /var/lib/containers/storage:/var/lib/containers/storage \
		quay.io/centos-bootc/bootc-image-builder:latest \
			--type qcow2 \
			--rootfs xfs \
			--chown $(shell id -u):$(shell id -g) \
			-v \
			--use-librepo \
			$(COZY_BOOTC_CONTAINER)

$(COZY_TESTVM_SNAP):
	qemu-img create \
		-f qcow2 \
		-F qcow2 \
		-b ./disk.qcow2 \
		$(COZY_TESTVM_SNAP)

cozy-run: $(COZY_TESTVM_SNAP)
	sudo virt-install \
		--connect qemu:///system \
		--name $(COZY_TESTVM_NAME) \
		--cpu host \
		--vcpus 8 \
		--memory 8192 \
		--import \
		--disk path=$(COZY_TESTVM_SNAP),format=qcow2 \
		--os-variant fedora-eln

cozy-rmvmimage: cozy-rmvm
	rm -f $(COZY_TESTVM_BASE)

cozy-rmvm:
	virsh \
		--connect qemu:///system \
		destroy \
		$(COZY_TESTVM_NAME) || true
	virsh \
		--connect qemu:///system \
		undefine \
		$(COZY_TESTVM_NAME) || true
	rm -f $(COZY_TESTVM_SNAP)


cozy-fresh: cozy-rmvmimage cozy-rmpack cozy-freshpack