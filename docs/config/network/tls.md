# TLS Certificate

*TAO Community Edition* requires HTTPS communication to support advanced features, and HTTPS protocol relies on trust relationship between server and browser.

Currently, we rely on [Caddy](https://caddyserver.com/) to route internal traffic and expose services.

Depending how you want to expose *TAO Community Edition*, you may choose from different methods to support TLS Certificate:

* you can keep self-signed certificate, however your users will always face a [warning from their browser](../../start/prepare.md#certificate-warning) at first connection

* for a [local usage](./public-lan.md#tls-certificate-signature), TLS Certificate signature can be challenging and requires a private Certificate Authority

* for a [public usage](./public-wan.md#tls-certificate-signature), [Caddy](https://caddyserver.com/) can attempt to automatically submit a certificate for signature.

Here is a short comparaison of those methods:


|              | Local self-signed | Local CA | Public CA |
|--------------|----------|-----------|------------|
|Automatic TLS |  ✅ not trusted | ❌       | ✅ trusted |
|Trusted CA by default | ❌ | ❌ | ✅ |
| Local-only |  ✅ | ✅ | ❌ |
| Setup complexity | low | high[^h] | medium[^m] | 
| Requires public DNS zone | ❌ | ❌ | ✅ |

!!! important "Keep in mind"

    Using a public domain for a local host may introduce [additional risks](https://letsencrypt.org/docs/certificates-for-localhost/) for your users.

[^h]: Local CA requires a [public key infrastructure](https://en.wikipedia.org/wiki/Public_key_infrastructure)
[^m]: Relying on Public CA requires a public DNS zone