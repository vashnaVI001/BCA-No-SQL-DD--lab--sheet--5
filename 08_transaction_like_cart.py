"""Exercise 8: Transaction-like multi-operation shopping-cart scenario.
This is application-level read/modify/write, NOT an atomic transaction.
"""
import json
import os
import requests

BASE = os.getenv("RIAK_URL", "http://127.0.0.1:8098").rstrip("/")
BUCKET = "shopping_carts"
KEY = "user-88-cart"
URL = f"{BASE}/buckets/{BUCKET}/keys/{KEY}"
HEADERS = {"Content-Type": "application/json"}

def save(cart):
    response = requests.put(URL, data=json.dumps(cart), headers=HEADERS, timeout=10)
    response.raise_for_status()

def load():
    response = requests.get(URL, timeout=10)
    if response.status_code == 404:
        return {"user_id": "user-88", "items": [], "total": 0.0}
    response.raise_for_status()
    return response.json()

cart = load()
# Operation 1: add item
cart["items"].append({"product_id": "P300", "quantity": 1, "price": 250.0})
cart["total"] = round(sum(i["quantity"] * i["price"] for i in cart["items"]), 2)
save(cart)

# Operation 2: update quantity
cart = load()
for item in cart["items"]:
    if item["product_id"] == "P300":
        item["quantity"] = 2
cart["total"] = round(sum(i["quantity"] * i["price"] for i in cart["items"]), 2)
save(cart)

print(json.dumps(load(), indent=2))
print("\nLimitation: concurrent clients can overwrite each other's changes. This sequence is not atomic.")
print("Use conditional updates/CRDTs where suitable, or a database with transactions if atomic multi-record changes are required.")
