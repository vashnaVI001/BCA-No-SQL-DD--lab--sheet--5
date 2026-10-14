#!/usr/bin/env bash
# Exercise 2: Store and retrieve a user session by its key.
set -euo pipefail
RIAK_URL="${RIAK_URL:-http://127.0.0.1:8098}"
BUCKET="user_sessions"
KEY="session-a7f31"
SESSION='{"session_id":"session-a7f31","user_id":"user-42","login_time":"2026-10-14T09:30:00+05:30","status":"active"}'

curl -sS -i -X PUT "$RIAK_URL/buckets/$BUCKET/keys/$KEY" \
  -H 'Content-Type: application/json' --data "$SESSION"
echo
curl -sS -i "$RIAK_URL/buckets/$BUCKET/keys/$KEY"
echo
