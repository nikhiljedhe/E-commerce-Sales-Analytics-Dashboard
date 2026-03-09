-- OLIS​T E-COMMERCE DATA ANALYSIS QUERIES

-- 1. View Orders Table
SELECT *
FROM olist_orders_dataset
LIMIT 10;


-- 2. Total Number of Orders
SELECT COUNT(*) AS total_orders
FROM olist_orders_dataset;


-- 3. Total Sales Revenue
SELECT SUM(payment_value) AS total_revenue
FROM olist_order_payments_dataset;


-- 4. Average Order Payment
SELECT AVG(payment_value) AS avg_order_value
FROM olist_order_payments_dataset;


-- 5. Orders by Status
SELECT order_status, COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;


-- 6. Monthly Order Trend
SELECT
DATE_TRUNC('month', order_purchase_timestamp) AS month,
COUNT(order_id) AS total_orders
FROM olist_orders_dataset
GROUP BY month
ORDER BY month;


-- 7. Top 10 Customers by Spending
SELECT
c.customer_unique_id,
SUM(p.payment_value) AS total_spent
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
ON c.customer_id = o.customer_id
JOIN olist_order_payments_dataset p
ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;


-- 8. Sales by Product Category
SELECT
pc.product_category_name,
SUM(oi.price) AS total_sales
FROM olist_order_items_dataset oi
JOIN olist_products_dataset pr
ON oi.product_id = pr.product_id
JOIN product_category_name_translation pc
ON pr.product_category_name = pc.product_category_name
GROUP BY pc.product_category_name
ORDER BY total_sales DESC;


-- 9. Average Delivery Time
SELECT
AVG(order_delivered_customer_date - order_purchase_timestamp) AS avg_delivery_time
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL;


-- 10. Top 10 Sellers by Revenue
SELECT
seller_id,
SUM(price) AS total_revenue
FROM olist_order_items_dataset
GROUP BY seller_id
ORDER BY total_revenue DESC
LIMIT 10;


-- 11. Orders by State
SELECT
c.customer_state,
COUNT(o.order_id) AS total_orders
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC;


-- 12. Payment Type Distribution
SELECT
payment_type,
COUNT(*) AS total_payments
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY total_payments DESC;


-- 13. Most Expensive Products
SELECT
product_id,
MAX(price) AS max_price
FROM olist_order_items_dataset
GROUP BY product_id
ORDER BY max_price DESC
LIMIT 10;


-- 14. Customer Segmentation by Spending
SELECT
c.customer_unique_id,
SUM(p.payment_value) AS total_spent,
CASE
WHEN SUM(p.payment_value) > 1000 THEN 'High Value'
WHEN SUM(p.payment_value) > 500 THEN 'Medium Value'
ELSE 'Low Value'
END AS customer_segment
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
ON c.customer_id = o.customer_id
JOIN olist_order_payments_dataset p
ON o.order_id = p.order_id
GROUP BY c.customer_unique_id;


-- 15. Running Revenue Trend
SELECT
DATE(order_purchase_timestamp) AS order_date,
SUM(payment_value) OVER (ORDER BY DATE(order_purchase_timestamp)) AS cumulative_revenue
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p
ON o.order_id = p.order_id;