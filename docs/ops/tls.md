# TLS for HTTPS

Ingress is powered by [Caddy](https://caddyserver.com/), which automatically generate self-signed CA certificate to support TLS.

In the case you want to deploy your own certificate, you need to edit [`/etc/tao-ce/config/Caddyfile`](/etc/tao-ce/config/Caddyfile).

Follow [`tls`](https://caddyserver.com/docs/caddyfile/directives/tls#tls) section in Caddy documentation.