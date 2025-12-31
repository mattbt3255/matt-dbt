-- Create the schema
CREATE SCHEMA raw;

-- Load all three files
CREATE TABLE raw.customers AS SELECT * FROM read_csv_auto('csvs/customers.csv');
CREATE TABLE raw.orders AS SELECT * FROM read_csv_auto('csvs/orders.csv');
CREATE TABLE raw.payments AS SELECT * FROM read_csv_auto('csvs/payments.csv');
.exit
