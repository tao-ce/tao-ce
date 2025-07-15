K3S_MANIFESTS_PATH=/workspace/.data/manifests

k3s/create: CHECK # $(CA_SECRET_FILE)
	sudo mkdir -p $(K3S_MANIFESTS_PATH)
	# sudo cp /workspace/.devcontainer
	kubectl kustomize $(PWD)/build/crystal | sudo tee $(K3S_MANIFESTS_PATH)/crystal-infra.yaml
	# kubectl kustomize $(PWD)/manifests/ingress | sudo tee $(K3S_MANIFESTS_PATH)/ingress.yaml

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
