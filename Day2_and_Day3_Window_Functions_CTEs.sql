# Window Functions
USE RetailCo;
GO
-- Q1 [EASY] - ROW_NUMBER basics
-- Assign a row number to each order 
-- per customer ordered by order_date ASC
-- Output: customer_id, order_id, 
--         order_date, row_num

SELECT 
    customer_id, 
    order_id, 
    order_date,
    ROW_NUMBER() OVER (PARTITION BY customer_id 
                       ORDER BY order_date ASC) AS row_num
FROM orders

SELECT DB_NAME()

-- ============================================
-- Q2 [EASY] - RANK
-- Rank customers by total revenue generated
-- Output: customer_id, name, 
--         total_revenue, revenue_rank
-- ============================================

-- Write your query here:
Select A.customer_id, A.name, Sum(C.total_amount) as total_revenue,
Rank () over (order by sum(C.total_amount) Desc)
from Customers A 
Join Orders C ON A.customer_id=C.customer_id
Group by A.customer_id, A.name

-- ============================================
-- Q3 [MEDIUM] - DENSE_RANK + PARTITION BY
-- Rank orders within each region 
-- by total_amount descending
-- Output: region, order_id, 
--         total_amount, rank_in_region
-- ============================================

-- Write your query here:
Select region, order_id, total_amount,
Dense_rank() over (partition by region order by total_amount DESC)
as rank_in_region
from Orders

-- ============================================
-- Q4 [MEDIUM] - LAG
-- For each customer show their current order 
-- amount AND their previous order amount
-- Output: customer_id, order_id, order_date,
--         total_amount, previous_order_amount
-- ============================================

Select customer_id, order_id, order_date,total_amount, lag(total_amount) over (partition by customer_id order by order_date) as
previous_order_amount 
from Orders

-- ============================================
-- Q5 [INTERVIEW LEVEL] - TOP N Per Group
-- Find TOP 2 customers by revenue 
-- in EACH region
-- Output: region, customer_id, name,
--         total_revenue, rank_in_region
-- Only show rank 1 and rank 2 per region
-- ============================================

-- Hints to think about:
-- Step 1: Calculate total revenue per 
--         customer per region
-- Step 2: Rank customers WITHIN each region
-- Step 3: Filter only rank 1 and 2

-- Which type of rank handles TIES better
-- for this business scenario?
-- RANK or DENSE_RANK?

-- Write your query here:

Select region, customer_id,name,total_revenue, rank_in_region from
(Select C.region, C.customer_id, A.name,SUM(C.total_amount) as total_revenue,
Dense_Rank() over(partition by C.region order by sum(c.total_amount) DESC )as rank_in_region
from Orders C
Join
Customers A ON A.customer_id = C.customer_id
Group by C.region, C. customer_id, A.name)t
where rank_in_region <3

# CTE
;WITH Customer_revenue as
(Select C.region, C.customer_id, A.name,SUM(C.total_amount) as total_revenue,
Dense_Rank() over(partition by C.region order by sum(c.total_amount) DESC )as rank_in_region
from Orders C
Join
Customers A ON A.customer_id = C.customer_id
Group by C.region, C. customer_id, A.name)
Select * from customer_revenue
where rank_in_region<3

-- ============================================
-- Q1 [EASY] - Basic CTE
-- Using a CTE, find all customers who have
-- placed more than 2 orders
-- Output: customer_id, name, total_orders
-- ============================================
;WITH customer_list as
(Select A.customer_id,A.name,Count(C.order_id) as total_orders from
Customers A
Join
Orders C ON
A.customer_id=C.Customer_id group by A.customer_id, A.name)
Select * from customer_list
where total_orders >2

-- Q2 [EASY] - CTE with JOIN
-- Using a CTE, calculate total revenue
-- per product category
-- Output: category, total_revenue
-- Sorted: highest first
;WITH product_revenue as
(Select B.category, sum(D.Quantity *D.unit_price) as total_revenue
from Products B
Join order_items D 
ON
B.product_id = D.Product_ID
group by B.category)
Select * from product_revenue
order by total_revenue DESC

-- Q3 [MEDIUM] - Chained CTEs
-- CTE 1: Calculate total revenue per customer
-- CTE 2: From CTE 1, find customers above
--        average revenue
-- Output: customer_id, name, total_revenue

;With 
total_revenue_Cust AS(Select A.customer_id, A.name, SUM(C.total_amount) as total_revenue from Customers A
Join Orders C ON
A.Customer_id=C.customer_id
group by A.Customer_id, A.name),

avg_rev_cust AS (Select avg(total_revenue) as avg_revenue from total_revenue_cust)
Select * from total_revenue_cust
where total_revenue > (Select avg_revenue from avg_rev_cust)


-- Q4 [MEDIUM] - CTE replacing complex subquery
-- Using a CTE, find the most expensive product
-- in each category
-- Output: category, product_name, cost_price
;With Exp_prdt as
(Select category, product_name,cost_price, dense_rank () over(partition by category order by cost_price DESC) as dn from products)
Select * from Exp_prdt
where dn=1

-- Q5 [INTERVIEW LEVEL] - AdTech Business Problem
-- You are a Yield Analyst at DataBeat.
-- Using CTEs find:
-- For each region, the month with the 
-- highest revenue in 2024
-- Output: region, best_month, monthly_revenue

;With 
CTE1 as
(Select region,month(order_date) as best_month, year(order_date) as order_year, sum(total_amount) as monthly_revenue from orders
group by region, month(order_date), year(order_date)),
CTE2 as
(Select region,best_month,order_year,monthly_revenue, dense_rank() over (partition by region order by monthly_revenue DESC)as dn from CTE1)
Select * from CTE2
where order_year=2024 and dn=1
