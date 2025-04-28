CLUSTER_NAME ?= default

K8S_FLAVOR ?= k3s

TLS_PATH=$(PWD)/.cache/tls
MANIFEST_PATH=$(PWD)/.devcontainer/$(K8S_FLAVOR)/manifests
INFRA_PATH=$(MANIFEST_PATH)/infra


###do not use dynamic variable (e.g. from env); this variable is a gatekeep to ensure make is not running on host system 
ENSURE_USER = vscode

CA_SUBJ := C=LU/ST=Luxembourg/L=Capellen/O=Open Assessment Technologies S.A./OU=DEV
CA_CN := CN=DEV CA DO NOT USE IN PRODUCTION OR PUBLIC
CA_SECRET_FILE := $(INFRA_PATH)/no-commit.cert-manager-ca-pair.yaml

WORKSPACE_BASHRC=${HOME}/.workspace_profile
DEVCONTAINER_BASHRC = ./.devcontainer/.bashrc
HOME_BASHRC ?= ${HOME}/.bashrc
DEFAULT_KUBECONFIG = ${HOME}/.kube/config
KUBECONFIG ?= $(DEFAULT_KUBECONFIG)

## internal Makefile stuffs
.DEFAULT_GOAL=WARN


# Targets

## gatekeeping targets
WARN:
	$(warning DO NOT RUN MAKE DIRECTLY UNLESS YOU ARE SURE OF WHAT YOU ARE DOING)
	$(warning targets in this Makefile are supposed to be automatically loaded from devcontainer)

CHECK:
ifneq "${USER}" "$(ENSURE_USER)"
	$(error Running user is ${USER}; $(ENSURE_USER) expected. Change ENSURE_USER variable in Makefile to force)
endif

include .devcontainer/Makefile.d/flavors/k3s.mk
include .devcontainer/Makefile.d/flavors/k3d.mk
include .devcontainer/Makefile.d/pki.mk
include .devcontainer/Makefile.d/devcontainer.mk

