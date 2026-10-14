#!/usr/bin/env bash
# Exercise 7: Insert a configurable number of records across multiple buckets.
# Demonstration only. Large values can put load on a small/dev cluster.
set -euo pipefail
RIAK_URL="${RIAK_URL:-http://127.0.0.1:8098}"
COUNT="${COUNT:-100}"
for bucket in students_load products_load orders_load; do
  echo "Writing $COUNT records to $bucket"
  for ((i=1; i<=COUNT; i++)); do
    key="${bucket}-${i}"
    payload="{\"id\":$i,\"bucket\":\"$bucket\",\"note\":\"horizontal scaling demo\"}"
    curl -fsS -X PUT "$RIAK_URL/buckets/$bucket/keys/$key" \
      -H 'Content-Type: application/json' --data "$payload" >/dev/null
  done
done
echo "Inserted $((COUNT * 3)) records. Inspect node/cluster status using tools supported by your Riak distribution."
echo "Riak partitions data across the cluster's ring; adding nodes can increase capacity, subject to rebalance and replication."
