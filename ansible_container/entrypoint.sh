#!/usr/bin/env bash
set -e
source /opt/venv/bin/activate

# Handle the provisioning of the gateway.
if [ "$1" = 'provision' ]; then
  readonly cloud_provider=$(xargs < /run/secrets/cloud_provider)
  exec ansible-playbook -i inventory.localhost.yml "playbook.provision.$cloud_provider.yml"
fi

# Handle the teardown of the gateway.
if [ "$1" = 'teardown' ]; then
  readonly cloud_provider=$(xargs < /run/secrets/cloud_provider)
  exec ansible-playbook -i inventory.localhost.yml "playbook.teardown.$cloud_provider.yml"
fi

exec "$@"
