# BCA305P-AS03 — NoSQL Database Design Lab Sheet 5

This repository contains code/examples for all 15 exercises in the supplied lab sheet:
- Exercises 1–10: Riak KV
- Exercises 11–15: Neo4j

## Important compatibility notes

- The Riak examples use the legacy Riak KV HTTP API (typically port `8098`). Riak KV is a legacy product and installation packages/images may not be readily available on current Linux distributions. Use a compatible Riak KV installation or lab VM.
- The Riak examples assume the bucket type `default` and legacy buckets. Riak configuration and API behavior can differ by version. Quorum examples (`r`, `w`, `dw`) are illustrative and must be tested against your actual cluster.
- The set example uses Riak data types (CRDT sets), which require a compatible Riak KV version and bucket type configured for sets. The example explains the required configuration; it is not interchangeable with a normal JSON object.
- Neo4j examples target Neo4j 5.x and Python 3.10+. Use Python driver 5.x/6.x.

## Repository layout

```text
riak/
  01_students_crud.sh
  02_user_sessions.sh
  03_user_profiles.sh
  04_shopping_cart.sh
  05_value_types.sh
  06_quorum_consistency.sh
  07_scaling_load.sh
  08_transaction_like_cart.py
  09_query_by_data.py
  10_sets_notes_and_commands.md
neo4j/
  requirements.txt
  .env.example
  11_student_course_department.cypher
  12_social_network.cypher
  13_ecommerce.cypher
  14_transactions.cypher
  15_graph_app.py
  queries/
    11_visualize_graph.cypher
```

## Running the Riak scripts

Install `curl` and `jq` on the Linux machine, make sure Riak KV is running, then:

```bash
export RIAK_URL=http://127.0.0.1:8098
bash riak/01_students_crud.sh
bash riak/02_user_sessions.sh
# Continue with scripts 03–07 similarly.
python3 riak/08_transaction_like_cart.py
python3 riak/09_query_by_data.py
```

Scripts 01–07 use the HTTP API and `curl`. Scripts 08–09 use Python `requests`:

```bash
python3 -m pip install requests
```

For script 09, the example stores a small collection and scans it in application logic. This is suitable for a lab demonstration, not a scalable production query. For large datasets, use an appropriate secondary-index/search design supported by the chosen Riak version.

## Running the Neo4j examples

1. Start Neo4j 5.x (Desktop, Aura, or local server).
2. Open Neo4j Browser and run the `.cypher` files in order.
3. To run the Python app:

```bash
cd neo4j
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
# Edit .env with your Neo4j connection details.
python 15_graph_app.py
```

Do not commit real credentials or `.env` to GitHub.

## GitHub upload

Extract the ZIP, open the extracted folder in a terminal, then:

```bash
git init
git add .
git commit -m "Add BCA305P NoSQL Lab Sheet 5 code"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPOSITORY.git
git push -u origin main
```

Replace the URL with your own GitHub repository URL.
