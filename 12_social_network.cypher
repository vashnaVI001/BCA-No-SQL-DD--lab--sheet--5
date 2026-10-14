// Exercise 12: Social graph and queries for friends/followers.
CREATE CONSTRAINT person_id IF NOT EXISTS
FOR (p:Person) REQUIRE p.person_id IS UNIQUE;

MERGE (a:Person {person_id: 'P1', name: 'Aarav'});
MERGE (b:Person {person_id: 'P2', name: 'Meera'});
MERGE (c:Person {person_id: 'P3', name: 'Kabir'});
MERGE (org:Company {name: 'Tech Solutions'});

MERGE (a)-[:FRIENDS_WITH]->(b);
MERGE (b)-[:FRIENDS_WITH]->(c);
MERGE (c)-[:FOLLOWS]->(a);
MERGE (b)-[:FOLLOWS]->(a);
MERGE (a)-[:WORKS_AT]->(org);

// Find a person's direct friends (the relationship is directed in this example).
MATCH (:Person {person_id: 'P1'})-[:FRIENDS_WITH]->(friend:Person)
RETURN friend.name AS friend;

// Find people who follow P1.
MATCH (follower:Person)-[:FOLLOWS]->(:Person {person_id: 'P1'})
RETURN follower.name AS follower;

// Find people P1 follows.
MATCH (:Person {person_id: 'P1'})-[:FOLLOWS]->(followed:Person)
RETURN followed.name AS followed;
