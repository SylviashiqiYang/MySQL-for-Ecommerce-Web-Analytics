USE mavenfuzzyfactory;

-- Business context: we want to see landing page performance for a certain time period

-- STEP 1 : find the first website_pageview_id for relevant sessions
-- STEP 2: identify the landing page for each session
-- STEP 3: Counting pageviews for each session, to identify "bounces"
-- STEP 4: summarizing total sessions and bounced sessions, by LP

-- finding the minimum webste pageview id associated with eachs session we cared about
SELECT 
	website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_pageview_id
FROM website_pageviews
INNER JOIN website_sessions
ON website_sessions.website_session_id = website_pageviews.website_session_id
AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY 
website_pageviews.website_session_id;

-- same query as above, but this time we are storing the datset as a temporary  table
CREATE TEMPORARY TABLE first_pageviews_demo
SELECT 
	website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_pageview_id
FROM website_pageviews
INNER JOIN website_sessions
ON website_sessions.website_session_id = website_pageviews.website_session_id
AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY 
website_pageviews.website_session_id;

SELECT * FROM first_pageviews_demo;

-- next we will bring in the landing page to each session
CREATE TEMPORARY TABLE sessions_w_landing_page_demo
SELECT
	first_pageviews_demo.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM first_pageviews_demo
LEFT JOIN website_pageviews
ON website_pageviews.website_pageview_id = first_pageviews_demo.min_pageview_id;  -- website pageview is the landing pageview

SELECT * FROM sessions_w_landing_page_demo;  -- QA ONLY


-- next, we make a table to include a count of pageviews per session
-- first, I'll show you all of the sessions, then we will limit to bounced sessions and create a temp table

-- CREATE TEMPTABLE bounced_sessions_only
CREATE TEMPORARY TABLE bounced_sessions_only
SELECT
	sessions_w_landing_page_demo.website_session_id,
    sessions_w_landing_page_demo.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM sessions_w_landing_page_demo
LEFT JOIN website_pageviews -- one to mant join
ON website_pageviews.website_session_id = sessions_w_landing_page_demo.website_session_id
GROUP BY 
	sessions_w_landing_page_demo.website_session_id,
	sessions_w_landing_page_demo.landing_page
HAVING
	COUNT(website_pageviews.website_pageview_id) = 1;
    
SELECT * FROM bounced_sessions_only; -- QA 

SELECT 
	sessions_w_landing_page_demo.landing_page,
    sessions_w_landing_page_demo.website_session_id,
    bounced_sessions_only.website_session_id AS bounced_website_session_id
FROM sessions_w_landing_page_demo
LEFT JOIN bounced_sessions_only
ON sessions_w_landing_page_demo.website_session_id = bounced_sessions_only.website_session_id
ORDER BY
sessions_w_landing_page_demo.website_session_id
;

-- final output
	-- we will use the same query we previously ran, and runa a count of records
    -- we will group by landing page, and then we'll add bounce rate column
    
SELECT
	sessions_w_landing_page_demo.landing_page,
    COUNT(DISTINCT sessions_w_landing_page_demo.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT bounced_sessions_only.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT bounced_sessions_only.website_session_id) / COUNT(DISTINCT sessions_w_landing_page_demo.website_session_id) AS bounce_rate
FROM sessions_w_landing_page_demo
LEFT JOIN bounced_sessions_only
ON sessions_w_landing_page_demo.website_session_id = bounced_sessions_only.website_session_id
GROUP BY sessions_w_landing_page_demo.landing_page;
-- cannot totally depend on the bounce rate because one landing page may serve as a segment of traffic that is particularly low quality
-- e.g displaying advertising 