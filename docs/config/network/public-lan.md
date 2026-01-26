# Access from LAN

Using *TAO Community Edition* locally is great, but you may find it more useful to share this service with multiple users.

On most systems, there are few steps to ensure your server can be reached outside your host:

* Open firewall rules
* Ensure Domain name can be resolved from clients
* TLS certificate signature (challenging but optional)

## Firewall rules

*TAO Community Edition* requires HTTPS port (TCP 443) to be opened and redirected to `tao` container. Docker Compose will try to redirect it automatically on startup.

Nevertheless, you may have to ensure this port is actually opened. This settings depends on your Operating System, and eventually on your host and network settings which can be enforced by your local system administrator.

=== "On Linux"

    * for firewall managed by [`firewalld`](https://firewalld.org/) (default on RHEL, CentOS or Fedora)
    ``` bash
    sudo firewall-cmd --permanent --add-port=443/tcp
    sudo firewall-cmd --reload
    ```

    * for firewall managed by [`ufw`](https://wiki.ubuntu.com/UncomplicatedFirewall) (default on Ubuntu and Debian)
    ``` bash
    suo ufw allow https
    ```



## Domain name resolution

Other machines on your network may need now to know how to resolve *TAO Community Edition* domain name, so they can contact your server with its LAN IP address.

=== "Using local DNS server"

    !!! abstract inline end "About DNS configuration"

        You may have to check documentation of your local DNS settings.


    Most of local network relies on [DHCP](https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol) to propagate network settings, which can help automatic DNS server configuration.


    If you are using custom DNS server (e.g. in a home router, organization network DNS server), you can add some `A` records here to resolve TAO domain name automatically to the hosting machine IP address.


=== "Using `/etc/hosts` file"

    !!! abstract inline end "About this method"
        This method is not really convenient for organization networks, as you may have dozen of hosts to update, and it might be preferable to configure a local DNS server.

    As described in [Preparation guide](../../start/prepare.md) following installation, you may have to update `/etc/hosts` file to let your clients know about your local IP addess. E.g.

    ```
    192.168.107.40  community.tao.internal
    ```

    This method is useful when you want to quickly test remote access to *TAO Community ddition* without changing too much settings on your network.

## TLS Certificate signature

*TAO Community Edition* requires HTTPS communication to support advanced features, and HTTPS protocol relies on trust relationship between server and browser.

__On a local network, it is not possible (by design) to rely on public certificate signature solution.__

Most of local services relies on self-signed certificate, which [trigger security warning](../../start/prepare.md#certificate-warning) in browsers.

!!! warning inline end "About private authority"

    Deploying a private authority, and trust such certificate can be significantly complex without technical knowledge on [public key infrastructure](https://en.wikipedia.org/wiki/Public_key_infrastructure).

    Attached instructions are for information only.

To remove [TLS security warning](../../start/prepare.md#certificate-warning) for your clients, the only solution is to provide [Caddy](https://caddyserver.com/) with a certificate signed from an authority which is explicitly trusted by your clients system.

You will be then required to:

* provision your own certificate authority (preferably with a signature chain)
* generate a private/public key for your server, with a certificate signature request
* sign the certificate signature request from certificate authority
* add this signed certificate and private server key in [`Caddyfile`](https://github.com/tao-ce/tao-ce/blob/main/etc/tao-ce/config/Caddyfile) (cf. [`tls` directive](https://caddyserver.com/docs/caddyfile/directives/tls))
* mount new `Caddyfile`, certificate and private key has volume in container.

Then you will have to add authority public key in trusted certificates for all your client systems. You may consider performing such deployment with a client management solution or [Group Policy](https://en.wikipedia.org/wiki/Group_Policy).


