#!/bin/sh

curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --header "Content-Type: application/json" \
    --request POST \
    --data '{"data": {"LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_USERNAME": "ray", "LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_PASSWORD": "super-secret-password"}}' \
    ${VAULT_ADDR}/v1/secret/data/liferay