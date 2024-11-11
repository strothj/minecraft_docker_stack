#!/bin/sh
set -e

chown -R caddy:caddy /config
chown -R caddy:caddy /data
chmod 700 /config /data

gosu caddy /usr/bin/caddy environ
exec gosu caddy /usr/bin/caddy run --config /config.json
