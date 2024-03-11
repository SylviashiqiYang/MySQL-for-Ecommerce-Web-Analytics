USE mavenfuzzyfactory;
-- pull bounce rates for traffic landing on the homepage
-- three numbers: sessions, bounced sessions and % of sessions which bounced

SELECT 
	website_session_id,
    MIN(website_pageview_id) AS min_pageview_id
FROM website_pageviews
WHERE created_at < '2012-06-14'
GROUP BY website_session_id;

-- Create a temporary table for the first viewed page
DROP TEMPORARY TABLE first_pageviews;

CREATE TEMPORARY TABLE first_pageviews
SELECT 
	website_session_id,
    MIN(website_pageview_id) AS min_pageview_id
FROM website_pageviews
WHERE created_at < '2012-06-14'
GROUP BY website_session_id;

SELECT * FROM first_pageviews; -- QA only

-- next we will bring in the landing page to each session
CREATE TEMPORARY TABLE sessions_w_home_landing_page
SELECT
	first_pageviews.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM first_pageviews
LEFT JOIN website_pageviews
ON website_pageviews.website_pageview_id = first_pageviews.min_pageview_id
WHERE website_pageviews.pageview_url = '/home';


SELECT * FROM sessions_w_home_landing_page;

-- bounced only 
CREATE TEMPORARY TABLE bounced_sessions
SELECT
	sessions_w_home_landing_page.website_session_id,
    sessions_w_home_landing_page.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM sessions_w_home_landing_page
LEFT JOIN website_pageviews -- one to mant join
ON website_pageviews.website_session_id = sessions_w_home_landing_page.website_session_id
GROUP BY 
	sessions_w_home_landing_page.website_session_id,
	sessions_w_home_landing_page.landing_page
HAVING
	COUNT(website_pageviews.website_pageview_id) = 1;
    


-- Caculating the bounce rate
SELECT
    COUNT(DISTINCT sessions_w_home_landing_page.website_session_id) AS total_sessions,
    COUNT(DISTINCT bounced_sessions.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT bounced_sessions.website_session_id) / COUNT(DISTINCT sessions_w_home_landing_page.website_session_id) AS bounce_rate
FROM sessions_w_home_landing_page
LEFT JOIN bounced_sessions
ON sessions_w_home_landing_page.website_session_id = bounced_sessions.website_session_id
GROUP BY sessions_w_home_landing_page.landing_page;

-- 59% of bounce rate, which is high and needs a lot of improvement
