USE mavenfuzzyfactory;

SELECT * FROM website_session;
SELECT * FROM website_pageviews;
SELECT * FROM orders;

-- Define relational DB
ALTER TABLE orders
ADD constraint FOREIGN KEY (website_session_id) REFERENCES website_sessions(website_session_id);

ALTER TABLE website_pageviews
ADD constraint FOREIGN KEY (website_session_id) REFERENCES website_sessions(website_session_id);

ALTER TABLE order_items
ADD constraint FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- campaign that has the best marketing performance for the period up to April 12, 2012 using UTM tracking parameters
SELECT
	utm_source,
    utm_campaign,
    http_referer,
    COUNT(website_session_id) number_of_sessions
FROM website_sessions
WHERE created_at < '2012-04-12'
AND utm_source IS NOT NULL
GROUP BY 1, 2, 3
ORDER BY 4 DESC;

-- It looks like non-brand gsearch is our main traffic source, but we need to understand if the sessions are driving sales.
-- Calculate the conversion rate (CVR) from session to order; Based on what we pay for clicks, we need a CVR of at least 4% for the numbers to work.
  SELECT 
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    (COUNT(DISTINCT o.order_id) / COUNT(DISTINCT ws.website_session_id)) * 100 AS session_to_order_conv_rate
FROM
    website_sessions ws
	LEFT JOIN orders o USING (website_session_id)
WHERE
    ws.created_at < '2012-04-12'
	AND ws.utm_source = 'gsearch'
    AND ws.utm_campaign = 'nonbrand';

-- A CVR value of 2.9% was obtained, meaning that the non-brand gsearch offer did not drive sales as expected, the investment did not go well
