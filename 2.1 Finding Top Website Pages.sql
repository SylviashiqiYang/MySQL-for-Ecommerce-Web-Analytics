use mavenfuzzyfactory;
-- Top content
SELECT 
	pageview_url,
    COUNT(DISTINCT website_pageview_id) AS pvs
FROM website_pageviews
WHERE website_pageview_id < 1000 -- arbitrary
GROUP BY pageview_url
ORDER BY pvs DESC;

-- entry page analysis
CREATE TEMPORARY TABLE first_pageview
SELECT 
	website_session_id,
    MIN(website_pageview_id) AS min_pv_id
FROM website_pageviews
WHERE website_pageview_id < 1000 -- arbitrary
GROUP BY website_session_id;

SELECT 
    website_pageviews.pageview_url AS landing_page,
    COUNT(DISTINCT first_pageview.website_session_id) AS sessions_hitting_this_lander-- aka 'entry page'
FROM first_pageview
LEFT JOIN website_pageviews
ON first_pageview.min_pv_id = website_pageviews.website_pageview_id
GROUP BY website_pageviews.pageview_url;