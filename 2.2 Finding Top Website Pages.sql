USE mavenfuzzyfactory;
-- find the most-viewed website pages, ranked by session volumne
SELECT 
pageview_url,
COUNT(DISTINCT website_pageview_id) AS pvs
FROM website_pageviews
WHERE created_at < '2012-06-09'
GROUP BY pageview_url
ORDER BY 
pvs DESC;
