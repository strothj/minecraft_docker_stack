#!/usr/bin/env bash
set -e

mkdir -p /home/tunnel/.ssh
cp /run/secrets/tunnel_authorized_keys /home/tunnel/.ssh/authorized_keys
cp /run/secrets/tunnel_ssh_host_ed25519_key /home/tunnel/.ssh/ssh_host_ed25519_key
chown -R tunnel:tunnel /home/tunnel/.ssh
chmod -R 0400 /home/tunnel/.ssh
chmod 0500 /home/tunnel/.ssh

exec "$@"
