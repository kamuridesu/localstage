#!/bin/bash

TOKEN_NAME="cli-export-$(date +%s)"

echo "Generating new admin token: $TOKEN_NAME..."

NEW_TOKEN=$(docker exec -u git forgejo forgejo admin user generate-access-token \
  --username forgejoadmin \
  --token-name "$TOKEN_NAME" \
  --raw | tr -d '\r')

if [ -z "$NEW_TOKEN" ]; then
    echo "Failed to generate token. Is the Forgejo container running?"
    return 1 2>/dev/null || exit 1
fi

export FORGEJO_ADMIN_TOKEN="$NEW_TOKEN"

echo "Token successfully exported!"
