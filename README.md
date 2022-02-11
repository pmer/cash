# The Cash Cache

Create self-signed TLS certificates for 3rd party sites and corresponding nginx
configs that use them and cache upstream resources.

## Usage

```bash
$ cat >sites.txt
cdnjs.cloudflare.com
ajax.googleapis.com
fonts.gstatic.com
cdn.jsdelivr.net
unpkg.com
EOF

$ ./main
```

One may cache as many sites as wished.

The first time it is run, a certificate authority will be generated and must be
installed. It is automatically installed in the macOS keychain, which Safari
and Chrome will pick up. It may be imported to Firefox via "Preferences" →
"Privacy & Security" → "Certificates" → "View Certificates" → "Authorities" →
"Import" → "Trust this CA to identify websites."

## How it works

It creates an entry in `/etc/hosts` for the site.

Nginx listens for the Host header in incoming requests to route the request to
upstream via its CNAME, A, AAAA record at time of installation since system
look-ups no longer work for the site on your computer.

Certificates are stored in `./certs` and cached responses are stored in `./cache-data`.
