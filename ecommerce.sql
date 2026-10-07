CREATE DATABASE ecommerce_dw;
USE ecommerce_dw;

CREATE TABLE dim_customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(100)
);

CREATE TABLE dim_product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE fact_orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    total_amount DECIMAL(12,2)
);

CREATE TABLE pipeline_metadata (
    pipeline_name VARCHAR(100) PRIMARY KEY,
    last_processed_order_id INT
);

INSERT INTO pipeline_metadata
VALUES ('ecommerce_orders', 0);

SELECT * FROM pipeline_metadata;

SELECT * FROM fact_orders;

SELECT * FROM dim_customer;

USE ecommerce_dw;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE fact_orders;
TRUNCATE TABLE dim_customer;
TRUNCATE TABLE dim_product;

SET FOREIGN_KEY_CHECKS = 1;

UPDATE pipeline_metadata
SET last_processed_order_id = 0
WHERE pipeline_name = 'ecommerce_orders';