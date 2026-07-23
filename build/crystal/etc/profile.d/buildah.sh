bcache(){ echo /var/tmp/buildah-cache-$(id -u)/$(echo -n "$1:0:0"| sha256sum | cut -c1-16 ); }
