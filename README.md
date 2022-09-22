# Liferay + Vault + Envconsul

Proof of concept using [Hashicorp Vault](https://github.com/hashicorp/vault) and [Hashicorp Envconsul](https://github.com/hashicorp/envconsul) to store secrets for Liferay and passing them as environment variables for the Liferay process only (and not system wide).

## Getting started

```shell
docker-compose up -d --build
```

## Structure

The Docker Compose of this project contains 4 services:

- Liferay DXP 7.4 (u42)
- MySQL 5.7
- Hashicorp Vault
- "Init", a custom container to store secrets into Vault

## Principle

The Docker Compose will start Vault and then our custom container will store 2 secrets in it that Liferay DXP will need:

```json
{
  "data": {
    "LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_USERNAME": "ray",
    "LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_PASSWORD": "super-secret-password"
  }
}
```

> You can find this data in [./init/secrets.json](init/secrets.json) which is used by [./init/init-secrets.sh](init/init-secrets.sh). This script is being copied into the container as described in [./init/Dockerfile](init/Dockerfile).

In order to fetch those secrets and add them as environment variables for Liferay DXP to use, we're taking advantage of Envconsul.

Envconsul allows to fetch secrets and add them as environment variables for a given process in a single command:

```shell
# Without config file
envconsul -no-prefix=true -upcase -vault-renew-token=false -vault-addr="${VAULT_ADDR}" -secret="secret/liferay" /usr/local/bin/liferay_entrypoint.sh

# With config file
envconsul -config "/opt/liferay/envconsul/config.hcl" -vault-addr="${VAULT_ADDR}" /usr/local/bin/liferay_entrypoint.sh
```

> The format is `envconsul {options} {process}` where you can have inline options, and all of them could be stored in a `.hcl` configuration file (e.g. [./liferay/config.hcl](liferay/config.hcl)).

So we're building our own [Dockerfile](liferay/Dockerfile) for Liferay DXP (based on the official image) to install Envconsul, copy our config file and update the entrypoint to let envconsul start the main process.

Once we start our Docker Compose, Liferay DXP successfully connect to the MySQL database using secrets retrieve into Vault and passed by Envconsul. There's something else we can check in our Liferay DXP container:

```shell
$ docker exec -it liferay-vault-envconsul_liferay_1 bash

> echo $LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_URL
jdbc:mysql://db/lportal?characterEncoding=UTF-8&dontTrackOpenResources=true&holdResultsOpenOverStatementClose=true&serverTimezone=GMT&useFastDateParsing=false&useUnicode=true

> echo $LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_PASSWORD

```

`LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_URL` is visible because we passed it as an environment variable in our [Docker Compose file](docker-compose.yml#L37) so it's system wide. But `$LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_PASSWORD` is not visible because Envconsul passed it as an environment variable for the entrypoint process.
