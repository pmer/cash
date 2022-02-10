#!/bin/sh
set -e

if [ $# -ne 1 ]; then
  echo >&2 'usage: $0 example.com'
  exit 1
fi

site=$1

openssl genrsa -out certs/$site.key 2048

openssl req -new -x509 -key certs/$site.key -out certs/$site.crt -days 365 -config /dev/stdin <<EOF
[ req ]
default_bits = 2048
default_md = sha256
prompt = no
encrypt_key = no
distinguished_name = dn

[ dn ]
C = US
O = HypaHub, Inc.
CN = $site
EOF
