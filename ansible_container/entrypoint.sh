#!/usr/bin/env bash
set -e
source /opt/venv/bin/activate

# Handle the provisioning of the gateway.
if [ "$1" = 'provision' ]; then
  readonly cloud_provider=$(xargs < /run/secrets/cloud_provider)
  exec ansible-playbook -i localhost "playbook.provision.$cloud_provider.yml"
fi

exec "$@"
