k3s/create: CHECK $(CA_SECRET_FILE)

k3s/start: CHECK $(WORKSPACE_BASHRC)
	grep -qF \
		'### load .workspace_profile' \
		$(HOME_BASHRC) \
	|| echo \
		". $(WORKSPACE_BASHRC) ### load .workspace_profile" \
		>>$(HOME_BASHRC)

k3s/ctx: CHECK
ifneq ($(KUBECONFIG),$(DEFAULT_KUBECONFIG))
	$(warning KUBECONFIG is defined; will not update it)
else
	mkdir -p $(shell dirname $(KUBECONFIG))
	sed -e "s@server:.*@server: $(K3S_URL)@" ${K3S_KUBECONFIG_OUTPUT} >$(KUBECONFIG)
endif

k3s/attach: CHECK k3s/ctx ctx
