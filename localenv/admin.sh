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
