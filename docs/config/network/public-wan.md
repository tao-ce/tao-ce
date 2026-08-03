# Access from Internet

!!! danger inline "About public server"

    Publishing a server on Internet may open your hosts, networks and services to significant security risk.

    We assume in this guide you are aware of such risk, and you will be liable for any related trouble.

If you feel you are ready to publish *TAO Community Edition* on Internet, let's see how we can do.

It is recommanded to have first ensure you can [connect locally to your server](./public-lan.md).

* Open firewall rules and redirect port 443
* Ensure Domain name can be resolved from Internet
* TLS Certificate signature (this step is automatic)

## Redirect incoming traffic to your server 

!!! abstract inline end "About traffic redirection"

    You may have to check documentation of your network equipment. Also, you may ensure your Internet provider is not blocking incoming traffic (e.g. with [CGNAT](https://en.wikipedia.org/wiki/Carrier-grade_NAT)).

As for [local setup](./public-lan.md), *TAO Community Edition* requires HTTPS port (TCP 443) to be opened and redirected to `tao` container.

Once your server has port opened, you may have to configure your local gateway (e.g. Internet router or modem), to route HTTPS traffic to your server.

You may eventually rely on reverse proxy to route your traffic internally.

## Domain name resolution

It is highly recommended to have a public custom domain name to ease name resolution on Internet. 

Other machines on Internet may need now to know how to resolve *TAO Community Edition* domain name, so they can contact your server with its LAN IP address.

=== "Using public DNS zone"

    !!! abstract inline end "About DNS configuration"

        You may have to check documentation of your DNS zone provider

    A public DNS zone is usually a collection of DNS records. Each record describe how to resolve a named query.

    In our case, you will have to create a [`A`](https://en.wikipedia.org/wiki/List_of_DNS_record_types#A) (and/or [`AAAA`](https://en.wikipedia.org/wiki/List_of_DNS_record_types#AAAA)) record, pointing to the public IP address of your server.
  

=== "Using `/etc/hosts` file"

    !!! failure inline end "About this method"
        This method is not really convenient for public access, and it might be preferable to configure a public DNS zone.

    As described in [Preparation guide](../../start/prepare.md) following installation, you may have to update `/etc/hosts` file to let your clients know about your local IP addess. E.g.

    ```
    198.51.100.47   tao.is-awesome.exemple.org   
    ```

    This method is useful only when you want to quickly test remote access to *TAO Community Edition* without waiting for DNS propagation.

## TLS Certificate signature

*TAO Community Edition* requires HTTPS communication to support advanced features, and HTTPS protocol relies on trust relationship between server and browser.

Currently, we rely on [Caddy](https://caddyserver.com/) to route internal traffic and expose services.

At startup, Caddy will [automatically](https://caddyserver.com/docs/automatic-https) attempt to obtain a signed certificate from [Let's Encrypt](https://letsencrypt.org/) (Free public certification authority). Unless your local administrator enforces some policies, such certificate are trusted by default on your browser.

Other signature method are not supported for now, however it might be possible to sign and mount your own TLS certificate and key, then update [`Caddyfile`](https://github.com/tao-ce/tao-ce/blob/main/etc/tao-ce/config/Caddyfile) to support other Certification Authority. 

You can check [`Caddtfile` reference documentation](https://caddyserver.com/docs/caddyfile/directives/tls) for more details.

