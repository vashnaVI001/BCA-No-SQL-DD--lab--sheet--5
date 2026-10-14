"""Exercise 9: Query-by-data using application-level filtering over sample JSON records.
For teaching only: key listing/scanning is not an efficient production query strategy.
"""
import json
import os
import requests

BASE = os.getenv("RIAK_URL", "http://127.0.0.1:8098").rstrip("/")
BUCKET = "query_users"
HEADERS = {"Content-Type": "application/json"}
USERS = [
    {"id": "u1", "name": "Aarav", "city": "Shamli", "age": 22, "preferences": ["music", "cricket"]},
    {"id": "u2", "name": "Meera", "city": "Dehradun", "age": 24, "preferences": ["reading", "music"]},
    {"id": "u3", "name": "Kabir", "city": "Shamli", "age": 20, "preferences": ["gaming"]},
]

def put(user):
    r = requests.put(f"{BASE}/buckets/{BUCKET}/keys/{user['id']}",
                     data=json.dumps(user), headers=HEADERS, timeout=10)
    r.raise_for_status()

def get(user_id):
    r = requests.get(f"{BASE}/buckets/{BUCKET}/keys/{user_id}", timeout=10)
    r.raise_for_status()
    return r.json()

for user in USERS:
    put(user)

records = [get(u["id"]) for u in USERS]
print("Users in Shamli:")
print(json.dumps([u for u in records if u["city"] == "Shamli"], indent=2))
print("\nUsers age >= 22:")
print(json.dumps([u for u in records if u["age"] >= 22], indent=2))
print("\nUsers who like music:")
print(json.dumps([u for u in records if "music" in u["preferences"]], indent=2))
print("\nProduction note: use Riak Search or secondary indexes if supported/configured for the data model.")
