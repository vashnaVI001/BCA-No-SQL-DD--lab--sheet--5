"""Exercise 15: Small Neo4j graph application demonstrating CRUD and relationship queries."""
import os
from dotenv import load_dotenv
from neo4j import GraphDatabase

load_dotenv()
URI = os.getenv("NEO4J_URI", "bolt://localhost:7687")
USERNAME = os.getenv("NEO4J_USERNAME", "neo4j")
PASSWORD = os.getenv("NEO4J_PASSWORD", "change-me")
DATABASE = os.getenv("NEO4J_DATABASE", "neo4j")

class GraphApp:
    def __init__(self):
        self.driver = GraphDatabase.driver(URI, auth=(USERNAME, PASSWORD))

    def close(self):
        self.driver.close()

    def create_student(self, student_id, name, course):
        query = """
        MERGE (s:Student {student_id: $student_id})
        SET s.name = $name, s.course = $course
        RETURN s.student_id AS id, s.name AS name, s.course AS course
        """
        with self.driver.session(database=DATABASE) as session:
            return session.execute_write(
                lambda tx: tx.run(query, student_id=student_id, name=name, course=course)
                .single().data()
            )

    def get_student(self, student_id):
        query = """
        MATCH (s:Student {student_id: $student_id})
        RETURN s.student_id AS id, s.name AS name, s.course AS course
        """
        with self.driver.session(database=DATABASE) as session:
            record = session.execute_read(
                lambda tx: tx.run(query, student_id=student_id).single()
            )
            return record.data() if record else None

    def update_student(self, student_id, name=None, course=None):
        query = """
        MATCH (s:Student {student_id: $student_id})
        SET s.name = coalesce($name, s.name),
            s.course = coalesce($course, s.course)
        RETURN s.student_id AS id, s.name AS name, s.course AS course
        """
        with self.driver.session(database=DATABASE) as session:
            record = session.execute_write(
                lambda tx: tx.run(query, student_id=student_id, name=name, course=course).single()
            )
            return record.data() if record else None

    def delete_student(self, student_id):
        query = "MATCH (s:Student {student_id: $student_id}) DETACH DELETE s RETURN count(*) AS deleted"
        # Use a separate match/count pattern because DELETE does not return deleted entities.
        query = """
        MATCH (s:Student {student_id: $student_id})
        WITH collect(s) AS found
        FOREACH (node IN found | DETACH DELETE node)
        RETURN size(found) AS deleted
        """
        with self.driver.session(database=DATABASE) as session:
            return session.execute_write(
                lambda tx: tx.run(query, student_id=student_id).single()["deleted"]
            )

    def create_relationship(self, student_id, course_name):
        query = """
        MATCH (s:Student {student_id: $student_id})
        MERGE (c:Course {name: $course_name})
        MERGE (s)-[:ENROLLED_IN]->(c)
        RETURN s.name AS student, c.name AS course
        """
        with self.driver.session(database=DATABASE) as session:
            record = session.execute_write(
                lambda tx: tx.run(query, student_id=student_id, course_name=course_name).single()
            )
            return record.data() if record else None

    def students_for_course(self, course_name):
        query = """
        MATCH (s:Student)-[:ENROLLED_IN]->(:Course {name: $course_name})
        RETURN s.student_id AS id, s.name AS name ORDER BY name
        """
        with self.driver.session(database=DATABASE) as session:
            return session.execute_read(
                lambda tx: [r.data() for r in tx.run(query, course_name=course_name)]
            )

def main():
    app = GraphApp()
    try:
        print("CREATE:", app.create_student("S900", "Sample Student", "BCA"))
        print("READ:", app.get_student("S900"))
        print("UPDATE:", app.update_student("S900", name="Updated Student"))
        print("RELATIONSHIP:", app.create_relationship("S900", "NoSQL Databases"))
        print("COURSE QUERY:", app.students_for_course("NoSQL Databases"))
        print("DELETE count:", app.delete_student("S900"))
    finally:
        app.close()

if __name__ == "__main__":
    main()
