# The Cash Cache

Create self-signed TLS certificates for 3rd party sites and corresponding nginx
configs that use them and cache upstream resources.

## Usage

```bash
site=cdn.jsdelivr.net

# Make a self-signed certificate for $site.
bin/generate-cert $site

# Install the certificate to your login keychain.
bin/install-certificate $site

# Create an nginx server configuration.
bin/install-nginx $site

# Run nginx
bin/run-nginx
```

One can cache as many sites as they wish.

## How it works

It creates an entry in `/etc/hosts` for the site.

Nginx listens for the Host header in incoming requests to route the request to
upstream via its CNAME, A, AAAA record at time of installation since system
look-ups no longer work for the site on your computer.
