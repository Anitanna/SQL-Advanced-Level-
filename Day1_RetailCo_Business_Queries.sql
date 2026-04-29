-- ================================================
-- DAY 1 — RetailCo Business SQL Practice
-- Topics: Aggregations, JOINs, Business Metrics,
--         Data Transformation, CASE WHEN
-- Author: Anit Anna Joseph
-- Date: April 29, 2026
-- ================================================

-- ------------------------------------------------
-- Q1: Top 5 Regions by Revenue — March 2024
-- Business Context: Sales VP weekly report
-- ------------------------------------------------
SELECT TOP 5 
    region, 
    SUM(total_amount) AS total_revenue 
FROM orders 
WHERE status = 'delivered' 
AND order_date >= '2024-03-01'
AND order_date <  '2024-04-01'
GROUP BY region  
ORDER BY total_revenue DESC;


-- ------------------------------------------------
-- Q2: Gold Customers Inactive for 90+ Days
-- Business Context: Customer retention campaign
-- Key Learning: LEFT JOIN + NULL pattern for 
--               "not exists" scenarios
-- ------------------------------------------------
SELECT 
    A.customer_id, 
    A.name, 
    A.email 
FROM customers A 
LEFT JOIN orders B 
    ON A.customer_id = B.customer_id 
    AND B.order_date >= DATEADD(DAY, -90, '2026-04-29')
WHERE A.tier = 'Gold' 
AND B.customer_id IS NULL;


-- ------------------------------------------------
-- Q3: Average Order Value (AOV) by Customer Tier
-- Business Context: Finance KPI report Q1 2024
-- Formula: AOV = Total Revenue / Number of Orders
-- ------------------------------------------------
SELECT 
    A.tier, 
    SUM(C.total_amount) / COUNT(C.order_id) AS AOV 
FROM customers A 
JOIN orders C ON A.customer_id = C.customer_id 
WHERE status = 'delivered' 
AND order_date BETWEEN '2024-01-01' AND '2024-03-31'
GROUP BY A.tier
ORDER BY AOV DESC;


-- ------------------------------------------------
-- Q4: Effective Revenue per Order (NULL safe)
-- Business Context: Revenue dashboard cleanup
-- Key Learning: ISNULL to handle NULL discounts
-- Formula: qty * unit_price * (1 - discount)
-- ------------------------------------------------
SELECT TOP 10 
    order_id, 
    SUM(quantity * unit_price * (1 - ISNULL(discount, 0))) 
        AS effective_revenue 
FROM order_items
GROUP BY order_id 
ORDER BY effective_revenue DESC;


-- ------------------------------------------------
-- Q5: High Risk Customers (Fraud Detection)
-- Business Context: >50% cancelled/returned orders
-- Key Learning: CASE WHEN inside COUNT,
--               HAVING on aggregated conditions,
--               100.0 for decimal division
-- ------------------------------------------------
WITH order_summary AS (
    SELECT 
        A.customer_id,
        A.name,
        COUNT(C.order_id) AS total_orders,
        COUNT(CASE WHEN C.status IN ('cancelled','returned') 
              THEN 1 ELSE NULL END) AS non_delivered_orders
    FROM customers A
    JOIN orders C ON A.customer_id = C.customer_id
    GROUP BY A.customer_id, A.name
)
SELECT 
    customer_id,
    name,
    total_orders,
    non_delivered_orders,
    (non_delivered_orders * 100.0 / total_orders) 
        AS non_delivered_pct
FROM order_summary
WHERE total_orders >= 3
AND (non_delivered_orders * 100.0 / total_orders) > 50
ORDER BY non_delivered_pct DESC;
