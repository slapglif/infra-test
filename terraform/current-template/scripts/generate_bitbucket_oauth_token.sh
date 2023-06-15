#!/bin/bash
API_ENDPOINT="https://bitbucket.org/site/oauth2/access_token"

CLIENT_ID="$TF_VAR_amplify_bitbucket_client_id"
CLIENT_SECRET="$TF_VAR_amplify_bitbucket_client_secret"

response=$(curl --silent POST -u "$CLIENT_ID:$CLIENT_SECRET" \
               -d "grant_type=client_credentials" \
               "$API_ENDPOINT")
oauth_token=$(echo "$response" | jq -r '.access_token')
echo "{\"oauth_token\": \"$oauth_token\"}"