#!/usr/bin/env bash
# Exercise 3: User profile and preferences, using PUT and GET.
set -euo pipefail
RIAK_URL="${RIAK_URL:-http://127.0.0.1:8098}"
BUCKET="user_profiles"
KEY="user-42"
PROFILE='{"user_id":"user-42","name":"Meera Verma","email":"meera@example.com","city":"Dehradun","preferences":{"language":"en","theme":"dark","notifications":true}}'

echo "PUT profile"
curl -sS -i -X PUT "$RIAK_URL/buckets/$BUCKET/keys/$KEY" \
  -H 'Content-Type: application/json' --data "$PROFILE"
echo -e "\nGET profile"
curl -sS -i "$RIAK_URL/buckets/$BUCKET/keys/$KEY"
echo
