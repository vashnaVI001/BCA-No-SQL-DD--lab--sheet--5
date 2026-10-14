// Exercise 11: Create Student, Course, Department nodes and relationships.
MATCH (n) DETACH DELETE n;

CREATE (d:Department {dept_id: 'D01', name: 'Computer Applications'});
CREATE (c1:Course {course_id: 'BCA', name: 'Bachelor of Computer Applications'});
CREATE (c2:Course {course_id: 'DBMS', name: 'Database Management Systems'});
CREATE (s1:Student {student_id: 'S101', name: 'Aarav Sharma', year: 3});
CREATE (s2:Student {student_id: 'S102', name: 'Meera Verma', year: 2});

CREATE (d)-[:OFFERS]->(c1);
CREATE (d)-[:OFFERS]->(c2);
CREATE (s1)-[:ENROLLED_IN]->(c1);
CREATE (s1)-[:STUDIES]->(c2);
CREATE (s2)-[:ENROLLED_IN]->(c1);

MATCH (s:Student)-[r]->(c:Course)
RETURN s, r, c;
