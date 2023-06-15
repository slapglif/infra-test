#!/bin/bash
export KEYCLOAK_CONTAINER_NAME=${keycloak_container_name}
export KEYCLOAK_ADMIN=${keycloak_admin}
export KEYCLOAK_ADMIN_PASSWORD=${keycloak_admin_password}
export KEYCLOAK_DB_ENDPOINT=${keycloak_db_endpoint}
export KEYCLOAK_DB_NAME=${keycloak_db_name}
export KEYCLOAK_DB_USER=${keycloak_db_user}
export KEYCLOAK_DB_PASSWORD=${keycloak_db_password}
#TODO: make this path configurable to have a possibility to use real certificates issued for domain in future
export SSL_FILES_DIR=/home/ubuntu/ssl-keys-dev

sudo apt update && sudo apt upgrade -y
sudo apt install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
newgrp docker

docker run -d \
 --name $KEYCLOAK_CONTAINER_NAME \
  -p 8443:8443 \
  -e KEYCLOAK_ADMIN=$KEYCLOAK_ADMIN -e KEYCLOAK_ADMIN_PASSWORD=$KEYCLOAK_ADMIN_PASSWORD \
  -e KC_HTTPS_CERTIFICATE_FILE=/opt/keycloak/conf/server.crt.pem \
  -e KC_HTTPS_CERTIFICATE_KEY_FILE=/opt/keycloak/conf/server.key.pem \
  -v $SSL_FILES_DIR/server.crt.pem:/opt/keycloak/conf/server.crt.pem \
  -v $SSL_FILES_DIR/server.key.pem:/opt/keycloak/conf/server.key.pem \
  quay.io/keycloak/keycloak:latest \
  start \
  --db=postgres  \
  --db-url=jdbc:postgresql://$KEYCLOAK_DB_ENDPOINT/$KEYCLOAK_DB_NAME \
  --db-username=$KEYCLOAK_DB_USER \
  --db-password=$KEYCLOAK_DB_PASSWORD \
  --hostname-strict=false
