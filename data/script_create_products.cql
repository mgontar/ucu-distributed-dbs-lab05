CREATE KEYSPACE "base"  WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };

CREATE TABLE base.products (id UUID, category text, model text, producer text, price double, properties map<text,text>, PRIMARY KEY(id, category));
CREATE INDEX ON base.products (category);
CREATE INDEX ON base.products (model);
CREATE INDEX ON base.products (producer);
CREATE INDEX ON base.products (price);
CREATE INDEX ON base.products (ENTRIES(properties));

CREATE MATERIALIZED VIEW base.products_by_category_price AS
       SELECT id FROM base.products
       WHERE category IS NOT NULL AND model IS NOT NULL AND producer IS NOT NULL AND price IS NOT NULL AND properties IS NOT NULL AND id IS NOT NULL
       PRIMARY KEY (category, price, id)
       WITH CLUSTERING ORDER BY (price desc);

CREATE MATERIALIZED VIEW base.products_by_category_model AS
       SELECT id FROM base.products
       WHERE category IS NOT NULL AND model IS NOT NULL AND producer IS NOT NULL AND price IS NOT NULL AND properties IS NOT NULL AND id IS NOT NULL
       PRIMARY KEY (category, model, id);

CREATE MATERIALIZED VIEW base.products_by_category_price_producer AS
       SELECT id, price FROM base.products
       WHERE category IS NOT NULL AND model IS NOT NULL AND producer IS NOT NULL AND price IS NOT NULL AND properties IS NOT NULL AND id IS NOT NULL
       PRIMARY KEY (category, producer, id);

COPY base.products (id, category, model, producer, price, properties) FROM '/root/data/products.csv' WITH DELIMITER='|' AND HEADER=TRUE;

DESCRIBE base.products;

SELECT * FROM base.products;

SELECT * FROM base.products_by_category_price WHERE category = 'Phone' ORDER BY price;

SELECT * FROM base.products_by_category_model WHERE category = 'Phone' AND model = 'IPhone 6';

SELECT * FROM base.products_by_category_price WHERE category = 'Phone' AND price > 0 AND price < 1200;

SELECT * FROM base.products_by_category_price_producer WHERE category = 'Phone' AND price = 800 AND producer = 'Apple' ALLOW FILTERING;

SELECT * FROM base.products WHERE properties CONTAINS KEY 'SIM' ALLOW FILTERING;

SELECT * FROM base.products WHERE category = 'Phone' AND properties['SIM'] = 'miniSIM' ALLOW FILTERING;

SELECT * FROM base.products WHERE category = 'Phone' AND id = f26b0b37-53e4-986b-a3b4-2256afcc7403;

UPDATE base.products SET properties['SIM'] = 'miniSIM' WHERE category = 'Phone' AND id = f26b0b37-53e4-986b-a3b4-2256afcc7403;

SELECT * FROM base.products WHERE category = 'Phone' AND id = f26b0b37-53e4-986b-a3b4-2256afcc7403;

UPDATE base.products SET properties = properties + {'Battery': '3000 mAh'} WHERE category = 'Phone' AND id = f26b0b37-53e4-986b-a3b4-2256afcc7403;

SELECT * FROM base.products WHERE category = 'Phone' AND id = f26b0b37-53e4-986b-a3b4-2256afcc7403;

UPDATE base.products SET properties = properties - {'Battery'} WHERE category = 'Phone' AND id = f26b0b37-53e4-986b-a3b4-2256afcc7403;

SELECT * FROM base.products WHERE category = 'Phone' AND id = f26b0b37-53e4-986b-a3b4-2256afcc7403;
