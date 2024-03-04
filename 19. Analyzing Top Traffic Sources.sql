use mavenfuzzyfactory;
-- anlysing top traffic sources
SELECT 
   utm_content,
   COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
   COUNT(DISTINCT orders.order_id) AS orders,
   COUNT(DISTINCT orders.order_id) /  COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conversion_rate
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.website_session_id BETWEEN 1000 AND 2000  -- aribtrary
GROUP BY 1
ORDER BY 2 DESC;

-- based on the result, we can have a conclusion that utm content g_ad_1 has the largest conversion rate
