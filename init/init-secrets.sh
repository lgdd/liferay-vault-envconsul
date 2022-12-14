#!/bin/sh

curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --header "Content-Type: application/json" \
    --request POST \
    --data @secrets.json \
    ${VAULT_ADDR}/v1/secret/data/liferay