# SQL-Interview-Prep
# [Day 1](https://github.com/Anitanna/SQL-Advanced-Level-/commit/90d7c5d2e4a3c47c27b46787c50a6e09febea808)
Practicing real-world SQL for Business Analyst 
and Data Analyst interviews.

## Database
RetailCo — a simulated e-commerce database with:
- customers, orders, order_items, products
- Real business scenarios: KPIs, fraud detection, 
  revenue analysis

## Tools
SQL Server (SSMS) | BigQuery compatible

##  Concepts Learned

### Day 1 — Aggregations + JOINs
| Concept | What It Does | Why We Use It |
|---------|-------------|---------------|
| WHERE vs HAVING | WHERE filters rows, HAVING filters groups | Use HAVING when filtering on SUM, COUNT, AVG |
| LEFT JOIN + IS NULL | Returns unmatched rows as NULL | Find customers who never ordered, inactive users |
| ISNULL(column, 0) | Replaces NULL with a value | Clean data before calculations, avoid NULL errors |
| CASE WHEN ELSE NULL in COUNT | Counts only rows meeting a condition | Count cancelled orders without a separate query |
| 100.0 not 100 | Forces decimal division | Avoid getting 0% instead of 66.7% in percentages |
| Date filter in ON not WHERE | Filters before NULL check | Critical for LEFT JOIN date range queries |

### Day 2 — Window Functions
| Concept | What It Does | Why We Use It |
|---------|-------------|---------------|
| ROW_NUMBER() | Unique number per row, no ties | Get first/last order per customer |
| RANK() | Same rank for ties, skips next number | Leaderboards where gaps matter |
| DENSE_RANK() | Same rank for ties, no skipping | Top N per group — most common in interviews |
| LAG() | Gets previous row value | Month over month comparison, trend analysis |
| LEAD() | Gets next row value | Predict next purchase, churn detection |
| PARTITION BY | Defines the group inside window | Rank within region, within tier, within category |
| No PARTITION BY | Ranks all rows together | Overall leaderboard across entire dataset |
| Subquery on window result | Wrap query to filter on rank | Can't use window alias in WHERE directly |

### Day 3 — CTEs
| Concept | What It Does | Why We Use It |
|---------|-------------|---------------|
| CTE | Named temporary result set | Break complex queries into readable steps |
| ;WITH syntax | SQL Server CTE declaration | Required semicolon before WITH in SQL Server |
| Chained CTEs | CTE2 reads from CTE1 | Above average analysis, benchmarking, KPI thresholds |
| Filter inside CTE | Reduces rows early | Better performance on large datasets |
| CTE + Window Function | Rank then filter | Top N per group — most powerful interview pattern |
| CTE vs Subquery | Same result, different style | CTE is cleaner, easier to debug, preferred in interviews |
