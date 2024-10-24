# Minecraft Docker Stack

## Infrastructure

### Gateway

The gateway is hosted on a cloud provider. Its purpose is to make available a
public IP address to local services using Docker containers configured for
reverse proxying.

### Server

The server is hosted on a local machine. Its purpose is to host Docker
containers for Minecraft servers, Discord bots, and databases.

## Secrets

To configure this project, remove the _.example_ suffix from the files in the
_secrets_ folder and populate them with appropriate values.

| File Name              | Description                                           | Supported Values |
| ---------------------- | ----------------------------------------------------- | ---------------- |
| cloud_provider         | The chosen cloud provider to host the gateway server. | vultr            |
| cloud_provider_api_key | The API key for the cloud provider.                   |                  |

## Docker Compose Files

| File Name                            | Description                    |
| ------------------------------------ | ------------------------------ |
| gateway.provision.docker-compose.yml | Provisions the gateway server. |
