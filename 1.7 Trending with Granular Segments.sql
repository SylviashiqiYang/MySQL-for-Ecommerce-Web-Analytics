use mavenfuzzyfactory;
-- after the device-level analysis of the coversion rate, we realizede dekktop was doing well, so bid our gsearch nonbrand
-- desktop campaign ups on 2012-05-19
-- pull weekly trends for both desktop and mobile so we can see the impact on volume?
SELECT 
MIN(DATE(created_at)) as week_start_date,
COUNT(DISTINCT(CASE WHEN device_type = 'desktop' then website_session_id ELSE NULL END)) as dtop_sessions,
COUNT(DISTINCT(CASE WHEN device_type = 'mobile' then website_session_id ELSE NULL END)) as mtop_sessions
FROM website_sessions
WHERE created_at < '2012-06-09'
AND created_at > '2012-04-15'
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY yearweek(created_at);
-- based on the result, mobile has pretty flat trends while desktop looking strong thanks to the bid change we made on previous conversion analysis
