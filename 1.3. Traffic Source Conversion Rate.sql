-- calcuate the Conversion Rate(CVR) from session to order, need CVR at least 4%
SELECT
COUNT(DISTINCT website_sessions.website_session_id) as sessions,
COUNT(DISTINCT orders.order_id) as orders,
COUNT(DISTINCT orders.order_id) /  COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conversion_rate
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-04-14'
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand';