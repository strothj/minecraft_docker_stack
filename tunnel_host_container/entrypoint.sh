#!/usr/bin/env bash
set -e

mkdir -p /home/tunnel/.ssh
chown -R tunnel:tunnel /home/tunnel/.ssh
chmod -R 0400 /home/tunnel/.ssh
chmod 0500 /home/tunnel/.ssh

exec "$@"
