MK_ROOT := $(PWD)

MK_BUILD_DIR := $(MK_ROOT)/build
MK_COZY_DIR := $(MK_BUILD_DIR)/cozy
MK_TLS_DIR := $(MK_BUILD_DIR)/tls
MK_SWIFT_DIR := $(MK_BUILD_DIR)/swift
MK_SBOM_DIR := $(MK_BUILD_DIR)/sbom

include \
	$(MK_TLS_DIR)/tls.mk \
	$(MK_COZY_DIR)/cozy.mk \
	$(MK_SWIFT_DIR)/swift.mk \
	$(MK_SBOM_DIR)/sbom.mk

crystal: tls-ca

cozy: tls-ca cozy-container cozy-vm-img

fresh: cozy-fresh tls-fresh 