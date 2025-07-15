COZY_TLS_DIR=$(COZY_CACHE_DIR)/tls
COZY_COCKPIT_CERT_DIR=$(COZY_TLS_DIR)/cockpit

# Create CSR from server key and CSR config
$(COZY_COCKPIT_CERT_DIR)/server.csr: $(COZY_CA_DIR)/ca.crt
	mkdir -p $(COZY_COCKPIT_CERT_DIR)
	openssl req \
		-copy_extensions=copyall \
		-out $(COZY_COCKPIT_CERT_DIR)/server.csr \
		-keyout $(COZY_COCKPIT_CERT_DIR)/server.key \
		-nodes -newkey rsa:4096 \
		-config $(COZY_CONFIG_DIR)/tls/cockpit.config.csr

# Sign CSR with CA key, and create server cert
$(COZY_COCKPIT_CERT_DIR)/server.crt: $(COZY_COCKPIT_CERT_DIR)/server.csr
	mkdir -p $(COZY_COCKPIT_CERT_DIR)
	openssl x509 -req \
		-days 730 \
		-CA $(COZY_CA_DIR)/ca.crt \
		-CAkey $(COZY_CA_DIR)/ca.key  \
		-in $(COZY_COCKPIT_CERT_DIR)/server.csr \
		-out $(COZY_COCKPIT_CERT_DIR)/server.crt \
		-copy_extensions=copyall