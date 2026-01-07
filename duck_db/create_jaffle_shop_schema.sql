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
INSERT INTO jaffle_shop.raw.orders (id, user_id, order_date, status, updated_at_utc, etl_loaded_at_utc)
VALUES
    (104, 83, '2018-04-14', 'placed', now(), '2026-01-02 09:34:14'::timestamp),
    (105, 92, '2018-04-15', 'placed', now(), '2026-01-02 09:34:14'::timestamp);

-- Update rows
UPDATE jaffle_shop.raw.orders 
SET status = 'return_pending' 
WHERE id = 24;

-- Add new column
ALTER TABLE jaffle_shop.raw.orders 
ADD column warehouse_id text;

UPDATE jaffle_shop.raw.orders
SET warehouse_id = 'ABC123';

-- Delete rows
DELETE FROM jaffle_shop.raw.orders 
WHERE id in (106, 107);
