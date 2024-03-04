-- Use date functions with GROUP BY and aggregate functions like COUNT() and SUM() to show trending
USE mavenfuzzyfactory;

SELECT 
     YEAR(created_at),
     WEEK(created_at),
     MIN(DATE(created_at)) AS week_start,
     COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE website_session_id BETWEEN 100000 AND 115000 -- arbitrary
GROUP BY 1,2;


-- pivoting data with COUNT and CASE
SELECT 
	primary_product_id,
    COUNT(DISTINCT CASE WHEN items_purchased = 1 THEN order_id ELSE NULL END) AS orders_w_1_items,
    COUNT(DISTINCT CASE WHEN items_purchased = 2 THEN order_id ELSE NULL END) As orders_w_2_items
FROM orders
WHERE order_id BETWEEN 31000 AND 32000  -- ARBITRARY
GROUP BY 1;