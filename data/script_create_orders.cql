CREATE KEYSPACE "base"  WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };


CREATE TABLE base.orders (id UUID, customer text, date timestamp, cost double, items list<frozen<tuple<UUID, int, double>>>, PRIMARY KEY (id, customer));
CREATE INDEX ON base.orders (customer);
CREATE INDEX ON base.orders (date);
CREATE INDEX ON base.orders (cost);
CREATE INDEX ON base.orders (items);

CREATE MATERIALIZED VIEW base.orders_by_customer_date AS
       SELECT id FROM base.orders
       WHERE customer IS NOT NULL AND date IS NOT NULL AND cost IS NOT NULL AND items IS NOT NULL AND id IS NOT NULL
       PRIMARY KEY (customer, date, id)
       WITH CLUSTERING ORDER BY (date desc);

CREATE MATERIALIZED VIEW base.orders_by_customer_cost AS
       SELECT id FROM base.orders
       WHERE customer IS NOT NULL AND date IS NOT NULL AND cost IS NOT NULL AND items IS NOT NULL AND id IS NOT NULL
       PRIMARY KEY (customer, cost, id);

COPY base.orders (id, customer, date, cost, items) FROM '/root/data/orders.csv' WITH DELIMITER='|' AND HEADER=TRUE;

DESCRIBE base.orders;

SELECT * FROM base.orders;

SELECT * FROM base.orders_by_customer_date WHERE customer = 'Abeu Von Hindenburg' ORDER BY date;

SELECT * FROM base.orders WHERE customer = 'Abeu Von Hindenburg' AND items CONTAINS (531f6eca-f441-29f9-254f-9539f30cb3ee, 1, 400) ALLOW FILTERING;

SELECT * FROM base.orders_by_customer_date WHERE customer = 'Abeu Von Hindenburg' AND date > '2017-01-01' AND date < '2017-12-30';

SELECT COUNT(*) FROM base.orders_by_customer_date WHERE customer = 'Abeu Von Hindenburg' AND date > '2017-01-01' AND date < '2017-12-30';


SELECT customer, avg(cost) FROM base.orders_by_customer_cost GROUP BY customer;

SELECT customer, sum(cost) FROM base.orders_by_customer_cost GROUP BY customer;

SELECT customer, id, max(cost) FROM base.orders_by_customer_cost GROUP BY customer;

SELECT * FROM base.orders WHERE customer = 'Abeu Von Hindenburg' AND id = c4f5c3cc-0a62-436b-ba7c-b1f5371ed6e9; 

UPDATE base.orders SET items = items + [(41eea1df-a3b6-bd0c-8cb1-02fd93cf9f21, 1, 1100)], cost = 1500.0 WHERE customer = 'Abeu Von Hindenburg' AND id = c4f5c3cc-0a62-436b-ba7c-b1f5371ed6e9; 

SELECT * FROM base.orders WHERE customer = 'Abeu Von Hindenburg' AND id = c4f5c3cc-0a62-436b-ba7c-b1f5371ed6e9; 

SELECT id, WRITETIME (cost) FROM base.orders;

INSERT INTO base.orders (id, customer, date, cost, items) 
VALUES (817495b0-1911-4dca-af5c-f4ccdf60ea83, 'Abeu Von Hindenburg', '2017-12-30', 400, [(13EAEFAC-EC5B-D86A-D943-8303ACF1C80E, 2, 200)]) USING TTL 5;

SELECT TTL (date) from base.orders WHERE customer = 'Abeu Von Hindenburg' AND id = 817495b0-1911-4dca-af5c-f4ccdf60ea83;

SELECT JSON * FROM base.orders WHERE customer = 'Abeu Von Hindenburg' AND id = c4f5c3cc-0a62-436b-ba7c-b1f5371ed6e9; 


INSERT INTO base.orders JSON '{"id": "fc179a90-dc58-4089-b3e6-8a3eecad7abd", "customer": "Abeu Von Hindenburg", "cost": 800.0, "date": "2017-10-25 00:00:00.000Z", "items": [["531f6eca-f441-29f9-254f-9539f30cb3ee", 2, 400.0]]}';

SELECT * FROM base.orders WHERE customer = 'Abeu Von Hindenburg' AND id = fc179a90-dc58-4089-b3e6-8a3eecad7abd; 

