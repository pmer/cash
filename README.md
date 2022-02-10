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
