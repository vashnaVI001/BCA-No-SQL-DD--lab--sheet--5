// Exercise 14: Transactions, consistency, and availability.
 // Run the block below as one query in Neo4j Browser. It commits atomically if successful.
CALL {
  CREATE (p:Person {person_id: 'TX1', name: 'Transaction Demo', status: 'new'})
  RETURN p
}
SET p.status = 'verified'
WITH p
CREATE (log:AuditLog {event: 'person_verified', created_at: datetime()})
CREATE (p)-[:HAS_AUDIT]->(log)
RETURN p, log;

// Separate transaction example: update then inspect.
MATCH (p:Person {person_id: 'TX1'})
SET p.status = 'active'
RETURN p;

// Delete demo record and its connected audit log (DETACH DELETE removes relationships).
MATCH (p:Person {person_id: 'TX1'})
DETACH DELETE p;

// ACID note: Neo4j transactions provide atomicity and consistency for committed graph changes.
// Availability is an architecture/deployment concern (for example, clustering and backups), not guaranteed by a single query.
