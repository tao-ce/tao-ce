SBOM_CACHE_DIR=$(MK_SBOM_DIR)/.cache


sbom-local:
	mkdir -p $(SBOM_CACHE_DIR)
	nerdctl image ls --format json  | jq -rsf $(MK_SBOM_DIR)/imagelist.jq | xargs -n1 syft scan --quiet -o json | gzip >$(SBOM_CACHE_DIR)/syft.json.gz


