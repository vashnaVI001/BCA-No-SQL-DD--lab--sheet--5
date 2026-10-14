#!/usr/bin/env bash
# Exercise 1: Basic CRUD operations for student records in Riak KV.
set -euo pipefail
RIAK_URL="${RIAK_URL:-http://127.0.0.1:8098}"
BUCKET="students"
KEY="student-1001"
CONTENT='{"student_id":"1001","name":"Aarav Sharma","course":"BCA","year":3}'

echo "PUT (create/store)"
curl -sS -i -X PUT "$RIAK_URL/buckets/$BUCKET/keys/$KEY" \
  -H 'Content-Type: application/json' --data "$CONTENT"
echo -e "\nGET (retrieve)"
curl -sS -i "$RIAK_URL/buckets/$BUCKET/keys/$KEY"
echo -e "\nPUT (update same key)"
UPDATED='{"student_id":"1001","name":"Aarav Sharma","course":"BCA","year":3,"city":"Shamli"}'
curl -sS -i -X PUT "$RIAK_URL/buckets/$BUCKET/keys/$KEY" \
  -H 'Content-Type: application/json' --data "$UPDATED"
echo -e "\nGET (verify update)"
curl -sS -i "$RIAK_URL/buckets/$BUCKET/keys/$KEY"
echo -e "\nDELETE"
curl -sS -i -X DELETE "$RIAK_URL/buckets/$BUCKET/keys/$KEY"
echo -e "\nGET after delete (should be not found / deleted)"
curl -sS -i "$RIAK_URL/buckets/$BUCKET/keys/$KEY" || true
echo
