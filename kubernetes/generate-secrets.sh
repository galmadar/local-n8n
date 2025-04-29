#!/bin/bash

# Check if .env file exists
if [ ! -f ./.env ]; then
  echo "Error: .env file not found in parent directory."
  exit 1
fi

# Source the .env file
source ./.env

# Generate the secret yaml
cat << EOF > postgres-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  namespace: n8n
  name: postgres-secret
type: Opaque
stringData:
  POSTGRES_USER: ${POSTGRES_USER}
  POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
  POSTGRES_DB: ${POSTGRES_DB}
  POSTGRES_NON_ROOT_USER: ${POSTGRES_NON_ROOT_USER}
  POSTGRES_NON_ROOT_PASSWORD: ${POSTGRES_NON_ROOT_PASSWORD}
EOF

echo "Secret file generated from .env values. Default values used for any missing variables." 