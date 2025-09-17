
COZY_VBOX_NAME="tao-ce-cozy"
COZY_VBOX_PATH=$(COZY_OUTPUT_DIR)/VirtualBox/$(COZY_VBOX_NAME)/$(COZY_VBOX_NAME).vbox

COZY_KEEP_VBOX="yes"

COZY_VDI_IMAGE=$(COZY_OUTPUT_DIR)/qcow2/disk.vdi
COZY_VBOX_OVA=$(COZY_OUTPUT_DIR)/qcow2/$(COZY_VBOX_NAME).ova


cozy-pack: $(COZY_VBOX_OVA)

cozy-rmpack:
	rm -f $(COZY_VBOX_OVA)

cozy-freshpack: cozy-rmpack
	-VBoxManage unregistervm $(COZY_VBOX_NAME) --delete-all

cozy-vdi-img: $(COZY_VDI_IMAGE)
$(COZY_VDI_IMAGE): $(COZY_TESTVM_BASE)
	qemu-img convert -f qcow2 $(COZY_TESTVM_BASE) \
		-O vdi \
		$(COZY_VDI_IMAGE)


$(COZY_VBOX_PATH): $(COZY_VDI_IMAGE)
	VBoxManage createvm --name $(COZY_VBOX_NAME) \
		--register \
		--ostype Fedora_64 \
		--basefolder $(COZY_OUTPUT_DIR)/VirtualBox/
	VBoxManage modifyvm $(COZY_VBOX_NAME) --ioapic on \
		--memory 8192 --vram 128 --cpus 8 \
		--nic1 bridged
	VBoxManage storagectl $(COZY_VBOX_NAME) \
		--name "SATA" \
		--add sata \
		--controller IntelAhci  \
		--portcount 1
	VBoxManage storageattach $(COZY_VBOX_NAME) \
		--storagectl "SATA" \
		--port 0 \
		--device 0 \
		--type hdd \
		--medium $(COZY_VDI_IMAGE)
	VBoxManage modifyvm $(COZY_VBOX_NAME) \
		--boot1 disk --boot2 none --boot3 none --boot4 none

$(COZY_VBOX_OVA): $(COZY_VBOX_PATH)
	VBoxManage export $(COZY_VBOX_NAME) \
		--output $(COZY_VBOX_OVA) \
		--ovf20 \
		--vsys 0 \
		--product="TAO Community Edition" \
		--vendor="Open Assessment Technologies S.A." \
		--vendorurl="https://www.taotesting.com/"
ifeq ( $(COZY_KEEP_VBOX), "no")
	VBoxManage unregistervm $(COZY_VBOX_NAME) --delete-all
endif