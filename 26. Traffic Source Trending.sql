USE  mavenfuzzyfactory;
-- pull gsearch nonbrand trended session volume, by week, to see if the bid changes have caused volume to drop it at all
SELECT 
-- yearweek(created_at),
MIN(DATE(created_at)) AS week_start_date,
COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE created_at < '2012-05-12'
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY yearweek(created_at); -- Note: you can group by things that are not appeared in the SELECT
