#!/usr/bin/env bash
# Exercise 4: Shopping cart operations. The cart is stored as one JSON value per user.
set -euo pipefail
RIAK_URL="${RIAK_URL:-http://127.0.0.1:8098}"
BUCKET="shopping_carts"
KEY="user-42-cart"

echo "1) Add two products"
CART='{"user_id":"user-42","items":[{"product_id":"P100","quantity":1,"price":499.0},{"product_id":"P200","quantity":2,"price":149.0}]}'
curl -sS -i -X PUT "$RIAK_URL/buckets/$BUCKET/keys/$KEY" \
  -H 'Content-Type: application/json' --data "$CART"
echo -e "\n2) Retrieve cart"
curl -sS -i "$RIAK_URL/buckets/$BUCKET/keys/$KEY"
echo -e "\n3) Update quantity for P100 to 3 (replace JSON value)"
UPDATED='{"user_id":"user-42","items":[{"product_id":"P100","quantity":3,"price":499.0},{"product_id":"P200","quantity":2,"price":149.0}]}'
curl -sS -i -X PUT "$RIAK_URL/buckets/$BUCKET/keys/$KEY" \
  -H 'Content-Type: application/json' --data "$UPDATED"
echo -e "\n4) Remove P200 (replace JSON value)"
REMOVED='{"user_id":"user-42","items":[{"product_id":"P100","quantity":3,"price":499.0}]}'
curl -sS -i -X PUT "$RIAK_URL/buckets/$BUCKET/keys/$KEY" \
  -H 'Content-Type: application/json' --data "$REMOVED"
echo -e "\n5) Verify final cart"
curl -sS -i "$RIAK_URL/buckets/$BUCKET/keys/$KEY"
echo
