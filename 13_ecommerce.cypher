// Exercise 13: E-commerce graph and products purchased by a customer.
CREATE CONSTRAINT customer_id IF NOT EXISTS
FOR (c:Customer) REQUIRE c.customer_id IS UNIQUE;
CREATE CONSTRAINT product_id IF NOT EXISTS
FOR (p:Product) REQUIRE p.product_id IS UNIQUE;
CREATE CONSTRAINT order_id IF NOT EXISTS
FOR (o:Order) REQUIRE o.order_id IS UNIQUE;

MERGE (customer:Customer {customer_id: 'C01', name: 'Riya'});
MERGE (category:Category {name: 'Accessories'});
MERGE (p1:Product {product_id: 'P01', name: 'Backpack', price: 899});
MERGE (p2:Product {product_id: 'P02', name: 'Bottle', price: 299});
MERGE (order:Order {order_id: 'O100', order_date: date('2026-10-14')});

MERGE (p1)-[:IN_CATEGORY]->(category);
MERGE (p2)-[:IN_CATEGORY]->(category);
MERGE (customer)-[:PLACED]->(order);
MERGE (order)-[:CONTAINS {quantity: 1}]->(p1);
MERGE (order)-[:CONTAINS {quantity: 2}]->(p2);

// Find products purchased by C01.
MATCH (:Customer {customer_id: 'C01'})-[:PLACED]->(:Order)-[line:CONTAINS]->(p:Product)
RETURN p.name AS product, p.price AS unit_price, line.quantity AS quantity;
