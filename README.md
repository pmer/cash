# The Cash Cache

Create self-signed TLS certificates for 3rd party sites and corresponding nginx
configs that use them and cache upstream resources.

## Usage

```bash
site=cdn.jsdelivr.net

# Make a self-signed certificate for $site.
./cert.sh $site

# Install the certificate to your system.

# Create an nginx server configuration.
./install.sh $site

# Run nginx
./nginx.sh
```

One can cache as many sites as they wish.

## How it works

It creates an entry in `/etc/hosts` for the site.

Nginx listens for the Host header in incoming requests to route the request to
upstream via its IP address since hostname look-ups no longer work for the site
on your computer.
