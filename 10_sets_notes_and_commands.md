# Exercise 10 — Set operations in Riak KV

Riak sets are CRDT data types, not ordinary JSON arrays. They must be used with a compatible Riak KV release and a bucket type configured for the `set` data type. Configuration varies by version, so verify your course VM before running commands.

Typical legacy HTTP API pattern (the exact endpoint and bucket-type setup can differ by version):

```bash
export RIAK_URL=http://127.0.0.1:8098
# Example bucket type name: sets (must be configured as a set data type first)
# Add values by updating the set with the correct multipart/form-data payload:
curl -i -X POST "$RIAK_URL/types/sets/buckets/user_interests/datatypes/user-42" \
  -H 'Content-Type: multipart/form-data' \
  -F 'adds=cricket' -F 'adds=music'
# Read set:
curl -i "$RIAK_URL/types/sets/buckets/user_interests/datatypes/user-42"
```

The data-type API's exact payload format is version-sensitive. Do not treat the above as a guaranteed copy/paste command for every Riak release.

Concepts to demonstrate in your lab report:
- **Add:** add an interest such as `music`.
- **Remove:** remove an interest such as `cricket`.
- **Membership:** retrieve the set and check whether `music` appears.
- **Common elements:** read two sets and calculate their intersection in application code.

Example application-side intersection:

```python
user_a = {"music", "cricket", "travel"}
user_b = {"music", "reading", "travel"}
print(user_a & user_b)  # {'music', 'travel'}
```

A CRDT set supports convergent updates across replicas, but set operations do not provide a general multi-record transaction.
