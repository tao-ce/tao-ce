
$(COZY_CACHE_DIR)/.dockerconfigjson:
	podman login \
		--compat-auth-file $(COZY_CACHE_DIR)/.dockerconfigjson \
		--username _json_key \
		--password-stdin \
		europe-west1-docker.pkg.dev \
			< $(POC_GAR_KEY)


