## bashrc management
$(WORKSPACE_BASHRC): CHECK
	rm -f $(WORKSPACE_BASHRC)
	ln -s $(PWD)/$(DEVCONTAINER_BASHRC) $(WORKSPACE_BASHRC)

## kube context management
ctx: CHECK
	kubectl config use-context $(CLUSTER_NAME)

create: $(K8S_FLAVOR)/create
start: $(K8S_FLAVOR)/start
attach: $(K8S_FLAVOR)/attach