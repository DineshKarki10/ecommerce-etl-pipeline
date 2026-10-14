-- 1. Total sales by product category
SELECT p.category, ROUND(SUM(fi.total_sales)::NUMERIC,2) AS total_sales
FROM fact_order_items fi
JOIN dim_product p ON p.product_id = fi.product_id
GROUP BY p.category
ORDER BY total_sales DESC;

-- 2. Monthly revenue
SELECT to_char(fo.order_date, 'YYYY-MM') AS month, ROUND(SUM(fi.total_sales)::NUMERIC,2) AS revenue
FROM fact_order_items fi
JOIN fact_orders fo ON fo.order_id = fi.order_id
GROUP BY month
ORDER BY month;

-- 3. Top 10 customers by revenue
SELECT c.customer_id, c.customer_name, ROUND(SUM(fi.total_sales)::NUMERIC,2) AS revenue
FROM fact_order_items fi
JOIN fact_orders fo ON fo.order_id = fi.order_id
JOIN dim_customer c ON c.customer_id = fo.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY revenue DESC
LIMIT 10;

-- 4. Top-performing products
SELECT p.product_id, p.product_name, p.category, SUM(fi.quantity) AS units_sold, ROUND(SUM(fi.total_sales)::NUMERIC,2) AS revenue
FROM fact_order_items fi
JOIN dim_product p ON p.product_id = fi.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY revenue DESC
LIMIT 10;

-- 5. Sales by region (country)
SELECT c.country, ROUND(SUM(fi.total_sales)::NUMERIC,2) AS revenue, COUNT(DISTINCT fo.order_id) AS num_orders
FROM fact_order_items fi
JOIN fact_orders fo ON fo.order_id = fi.order_id
JOIN dim_customer c ON c.customer_id = fo.customer_id
GROUP BY c.country
ORDER BY revenue DESC;

-- 6. Average order value
SELECT ROUND(AVG(order_total)::NUMERIC,2) AS aov
FROM (
  SELECT fo.order_id, SUM(fi.total_sales) AS order_total
  FROM fact_order_items fi
  JOIN fact_orders fo ON fo.order_id = fi.order_id
  GROUP BY fo.order_id
) t;

-- 7. Number of orders by month
SELECT to_char(fo.order_date, 'YYYY-MM') AS month, COUNT(DISTINCT fo.order_id) AS num_orders
FROM fact_orders fo
GROUP BY month
ORDER BY month;

-- 8. Products with sales above average
WITH prod_sales AS (
  SELECT p.product_id, p.product_name, SUM(fi.total_sales) AS rev
  FROM fact_order_items fi
  JOIN dim_product p ON p.product_id = fi.product_id
  GROUP BY p.product_id, p.product_name
), avg_rev AS (
  SELECT AVG(rev) AS avg_rev FROM prod_sales
)
SELECT ps.product_id, ps.product_name, ROUND(ps.rev::NUMERIC,2) AS revenue
FROM prod_sales ps
JOIN avg_rev av ON ps.rev > av.avg_rev
ORDER BY revenue DESC
LIMIT 20;
