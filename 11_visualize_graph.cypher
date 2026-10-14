// Exercise 11: Return nodes and relationships so Neo4j Browser can visualize them.
MATCH (n)-[r]->(m)
RETURN n, r, m;
