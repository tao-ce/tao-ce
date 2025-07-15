
CA_SUBJ := C=LU/ST=Luxembourg/L=Capellen/O=Open Assessment Technologies S.A./OU=TAO Community Edition
CA_CN := CN=TAO Community Edition

TLS_PATH=$(MK_TLS_DIR)/.cache

tls-ca: $(TLS_PATH)/ca.crt

# Create CA key and cert
$(TLS_PATH)/ca.crt:
	mkdir -p $(TLS_PATH)
	openssl req \
		-x509 -sha256 -nodes \
		-days 7300 \
		-newkey rsa:4096 \
		-subj '/$(CA_SUBJ)/$(CA_CN)' \
		-keyout ${TLS_PATH}/ca.key \
		-out ${TLS_PATH}/ca.crt

tls-fresh:
	rm $(TLS_PATH)/*