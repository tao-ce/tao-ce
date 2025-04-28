k3d/create: CHECK
	-k3d cluster create $(CLUSTER_NAME) --config conf/cluster.k3d.yml

k3d/start: CHECK $(WORKSPACE_BASHRC)
	grep -qF \
		'### load .workspace_profile' \
		$(HOME_BASHRC) \
	|| echo \
		". $(WORKSPACE_BASHRC) ### load .workspace_profile" \
		>>$(HOME_BASHRC)

k3d/attach: CHECK
	-k3d kubeconfig merge -ad
	-kubectl config use-context k3d-$(CLUSTER_NAME)
	true

