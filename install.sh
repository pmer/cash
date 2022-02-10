#!/bin/sh
set -e

if [ $# -ne 1 ]; then
  echo >&2 'usage: $0 example.com'
  exit 1
fi

site=$1

ip=`dig +short $1 | head -n 1`

mkdir -p cache-data

cat > /opt/homebrew/etc/nginx/servers/cache.conf <<EOF
proxy_cache_path $PWD/cache-data keys_zone=cash:10080m;
server_names_hash_bucket_size 64;
server_names_hash_max_size 512;
EOF

cat > /opt/homebrew/etc/nginx/servers/$site.conf <<EOF
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    ssl_certificate $PWD/certs/$site.crt;
    ssl_certificate_key $PWD/certs/$site.key;

    server_name $site;

    location / {
        proxy_pass https://$ip;
        proxy_set_header Host $site;
        proxy_http_version 1.1;
        proxy_cache cash;  # Must match name from proxy_cache_path.
        proxy_cache_valid any 10080m;  # one week
        proxy_buffering on;  # Needed for cache to work. That this is so might be a bug in nginx...

        proxy_ignore_headers Cache-Control;
        proxy_ignore_headers Expires;
        proxy_hide_header Cache-Control;
        proxy_hide_header Expires;

        proxy_hide_header Content-Security-Policy;

        add_header Cash-Status \$upstream_cache_status;  # Show HIT or MISS.
        add_header Cash-Date \$upstream_http_date;  # Show date.
    }
}
EOF

sudo cp /etc/hosts /etc/hosts.`date +%s`

sudo sed -i '' /$site/d /etc/hosts
sudo sh -c "echo 127.0.0.1 $site >> /etc/hosts"
