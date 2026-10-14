#!/usr/bin/env bash
# Exercise 5: Store strings, JSON documents, and list values.
set -euo pipefail
RIAK_URL="${RIAK_URL:-http://127.0.0.1:8098}"

curl -sS -i -X PUT "$RIAK_URL/buckets/lab_values/keys/greeting" \
  -H 'Content-Type: text/plain' --data 'Hello from Riak KV'
echo
curl -sS -i -X PUT "$RIAK_URL/buckets/lab_values/keys/student-json" \
  -H 'Content-Type: application/json' \
  --data '{"name":"Kabir","marks":[78,84,91]}'
echo
curl -sS -i -X PUT "$RIAK_URL/buckets/lab_values/keys/subjects-list" \
  -H 'Content-Type: application/json' \
  --data '["DBMS","Java","Computer Networks"]'
echo
echo "Read each value:"
for key in greeting student-json subjects-list; do
  echo "--- $key ---"
  curl -sS "$RIAK_URL/buckets/lab_values/keys/$key"
  echo
done
# Bucket = collection/namespace; key = unique identifier within bucket; value = stored payload.
