DIST_CA_DIR=~/.mozilla/certificates


### generate k8s secrets from CA cert
$(CA_SECRET_FILE): $(TLS_PATH)/ca.crt $(DIST_CA_DIR)/local.crt
	kubectl create secret tls \
		-o yaml --dry-run=client \
		-n cert-manager \
		local-ca-pair \
		--key=${TLS_PATH}/ca.key \
		--cert=${TLS_PATH}/ca.crt \
			> $(CA_SECRET_FILE)

### trust CA in devcontainer
$(DIST_CA_DIR)/local.crt: $(TLS_PATH)/ca.crt
	mkdir -p $(DIST_CA_DIR)
	cp $(TLS_PATH)/ca.crt $(DIST_CA_DIR)/local.crt

### generate CA cert and key
$(TLS_PATH)/ca.crt:
	mkdir -p $(TLS_PATH)
	openssl req \
		-x509 -sha256 -nodes \
		-days 7300 \
		-newkey rsa:2048 \
		-subj '/$(CA_SUBJ)/$(CA_CN)' \
		-keyout ${TLS_PATH}/ca.key \
		-out ${TLS_PATH}/ca.crt

### remove CA cert, key and k8s secret (those file should be in .gitignore)
wipeca:
	rm -f \
		$(TLS_PATH)/ca.crt \
		$(TLS_PATH)/ca.key \
		$(CA_SECRET_FILE)
