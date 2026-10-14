#!/usr/bin/env bash
# Exercise 6: Demonstrate read/write quorum parameters where supported by this Riak version.
# n_val, r, w and dw are cluster/version-dependent; verify your cluster's bucket properties.
set -euo pipefail
RIAK_URL="${RIAK_URL:-http://127.0.0.1:8098}"
BUCKET="quorum_demo"
KEY="record-1"
VALUE='{"message":"quorum test","version":1}'

echo "Write with w=2 and dw=1 (example settings)"
curl -sS -i -X PUT "$RIAK_URL/buckets/$BUCKET/keys/$KEY?w=2&dw=1" \
  -H 'Content-Type: application/json' --data "$VALUE"
echo -e "\nRead with r=2"
curl -sS -i "$RIAK_URL/buckets/$BUCKET/keys/$KEY?r=2"
echo
echo "Interpretation: w/r request acknowledgements from replicas; dw requests durable-write acknowledgement."
echo "A quorum setting is not a full multi-key transaction or a guarantee of linearizability."
