-- Breakdown by UTM source, campaign and referring domain
USE mavenfuzzyfactory;

SELECT utm_source,
       utm_campaign,
       http_referer,
       COUNT(DISTINCT website_sessions.website_session_id) AS sessions
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-04-12'
GROUP BY 1,2,3
ORDER BY 4 DESC;
