CREATE TABLE IF NOT EXISTS dim_customer (customer_id VARCHAR(20) PRIMARY KEY, customer_name VARCHAR(100), country VARCHAR(50), state VARCHAR(50), city VARCHAR(50));

CREATE TABLE IF NOT EXISTS dim_product (product_id VARCHAR(20) PRIMARY KEY, product_name VARCHAR(150), category VARCHAR(50), sub_category VARCHAR(50), brand VARCHAR(50));

CREATE TABLE IF NOT EXISTS fact_orders (order_id VARCHAR(20) PRIMARY KEY, customer_id VARCHAR(20), order_date TIMESTAMP, ship_date TIMESTAMP, delivery_date TIMESTAMP, payment_method VARCHAR(50), shipping_cost NUMERIC(10,4), CONSTRAINT fk_fact_orders_customer FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id));

CREATE TABLE IF NOT EXISTS fact_order_items (order_item_id INT PRIMARY KEY, order_id VARCHAR(20), product_id VARCHAR(20), quantity INT, unit_price NUMERIC(10,4), discount NUMERIC(10,4), total_sales NUMERIC(12,4), CONSTRAINT fk_fact_order_items_order FOREIGN KEY (order_id) REFERENCES fact_orders(order_id), CONSTRAINT fk_fact_order_items_product FOREIGN KEY (product_id) REFERENCES dim_product(product_id));
