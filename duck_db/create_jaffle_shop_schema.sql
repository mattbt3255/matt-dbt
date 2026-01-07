-- Create the database
$ duckdb duck_db/jaffle_shop.duckdb

-- Create the schema
CREATE SCHEMA raw;

-- Load all three tables with CSVs
CREATE TABLE raw.customers AS SELECT * FROM read_csv_auto('duck_db/csvs/customers.csv');
CREATE TABLE raw.orders AS SELECT * FROM read_csv_auto('duck_db/csvs/orders.csv');
CREATE TABLE raw.payments AS SELECT * FROM read_csv_auto('duck_db/csvs/payments.csv');
.exit

-- Add new rows
INSERT INTO jaffle_shop.raw.orders (id, user_id, order_date, status, updated_at_utc)
VALUES
    (102, 83, '2018-04-12', 'placed', now()),
    (103, 92, '2018-04-13', 'placed', now());

-- Update rows
UPDATE jaffle_shop.raw.orders 
SET status = 'return_pending' 
WHERE id = 24;
