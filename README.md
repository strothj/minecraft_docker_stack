# Minecraft Docker Stack

## Infrastructure

### Gateway

The gateway is hosted on a cloud provider. Its purpose is to make available a
public IP address to local services using Docker containers configured for
reverse proxying.

You can add the gateway as a Docker context:

```shell
docker context create minecraft_docker_stack --docker "host=ssh://root@123.123.123.123"
```

You can point your SSH agent to the private key:
`~/.ssh/config`:

```
# Minecraft Gateway
Host 123.123.123.123
  IdentityFile ~/code/minecraft_docker_stack/secrets/gateway_ssh_key
```

#### Ports

| Port  | Allowed Sources      | Description                                                                                   |
| ----- | -------------------- | --------------------------------------------------------------------------------------------- |
| 22    | Ansible control node | Allows Ansible to administer the gateway                                                      |
| 1022  | Server               | SSH container which allows remote port forwards. Exposes the Minecraft ports 25564 and 26665. |
| 25562 | 127.0.0.1            | Reverse port forward to server for the Minecraft staging server                               |
| 25563 | 127.0.0.1            | Reverse port forward to server for the Minecraft production server                            |
| 25564 | Any                  | Caddy proxy to 25562 using Proxy Protocol V2 to Minecraft staging server                      |
| 25565 | Any                  | Caddy proxy to 25563 using Proxy Protocol V2 to Minecraft production server                   |

Note: Caddy is used to proxy incoming Minecraft TCP connections to the Minecraft
ports. This is done using Proxy Protocol V2 so that source IP addresses are sent
along with the connection for use in the Minecraft authentication plugin
(AuthMeReloaded).

### Server

The server is hosted on a local machine. Its purpose is to host Docker
containers for Minecraft servers, Discord bots, and databases.

## Secrets

To configure this project, remove the _.example_ suffix from the files in the
_secrets_ folder and populate them with appropriate values.

| File Name                          | Description                                                                | Supported Values | Must Be Unique on Cloud Provider |
| ---------------------------------- | -------------------------------------------------------------------------- | ---------------- | -------------------------------- |
| cloud_provider                     | The chosen cloud provider to host the gateway server.                      | vultr            |                                  |
| cloud_provider_api_key             | The API key for the cloud provider.                                        |                  |                                  |
| gateway_control_node_ips           | The IP v4 and v6 addresses of control nodes with optional netmasks.        |                  |                                  |
| gateway_firewall_group_description | The description of the firewall group to create on the cloud provider.     |                  | True                             |
| gateway_hostname                   | The hostname of the gateway server.                                        |                  |                                  |
| gateway_instance_label             | The label of the instance to create on the cloud provider.                 |                  | True                             |
| gateway_ssh_key                    | The SSH key to use for connecting to the gateway server.                   |                  |                                  |
| gateway_ssh_key_name               | The name of the SSH key to use for connecting to the gateway server.       |                  | True                             |
| gateway_ssh_key_public_key         | The public key of the SSH key to use for connecting to the gateway server. |                  |                                  |
| timezone                           | The timezone in Linux format, e.g., `America/New_York`                     |                  |                                  |

## Docker Compose Files

| File Name                                    | Description                       |
| -------------------------------------------- | --------------------------------- |
| ansible.gateway.provision.docker-compose.yml | Provisions the gateway server.    |
| ansible.gateway.setup.docker-compose.yml     | Setup services on gateway server. |
| ansible.gateway.teardown.docker-compose.yml  | Tear down gateway server.         |
