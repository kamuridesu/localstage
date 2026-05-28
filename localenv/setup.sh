#!/bin/bash

REQUIRED_TOOLING="kubectl docker minikube helm"

if ! docker compose version >/dev/null 2>&1; then
    echo "Docker Compose V2 must be installed"
    exit 1
fi

for i in $REQUIRED_TOOLING; do
    if ! command -v "$i" &> /dev/null; then
        echo "Required command '$i' not found in PATH"
        exit 1
    fi
done

cd ./forgejo
bash ./setup.sh || exit 1
cd ..

cd ./minikube/
bash ./setup.sh || exit 1
cd ..

echo "Exporting Forgejo admin token"
source ./forgejo/export-admin-token.sh

echo "Creating app-config.local.yaml"
cat << EOF > ../app-config.local.yaml
integrations:
  gitea:
    - host: localhost:3000
      baseUrl: http://localhost:3000
      apiBaseUrl: http://localhost:3000/api/v1
      username: forgejoadmin
      password: ${FORGEJO_ADMIN_TOKEN}
backend:
  reading:
    allow:
      - host: localhost:3000
EOF


echo "ArgoCD admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

echo "Finished!"
