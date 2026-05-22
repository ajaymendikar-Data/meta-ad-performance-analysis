-- 2. Gender Analysis -- 

SELECT 
    u.user_gender,
    COUNT(*) AS engagements
FROM meta e
JOIN users u ON e.user_id = u.user_id
WHERE e.event_type IN ('Click','Share','Comment')
GROUP BY u.user_gender
ORDER BY engagements DESC;

-- 3. Age Group Analysis --

SELECT 
    u.age_group,
    COUNT(*) AS engagements
FROM meta e
JOIN users u ON e.user_id = u.user_id
WHERE e.event_type IN ('Click','Share','Comment')
GROUP BY u.age_group
ORDER BY engagements DESC;

-- 4. Country Performance (Map) ---

SELECT 
    u.country,
    COUNT(*) AS engagements
FROM Meta e
JOIN users u ON e.user_id = u.user_id
WHERE e.event_type IN ('Click','Share','Comment')
GROUP BY u.country
ORDER BY engagements DESC;


-- 5. Hourly Trend --

SELECT 
    time_of_day AS hour,
    COUNT(*) AS engagements
FROM Meta
WHERE event_type IN ('Click','Share','Comment')
GROUP BY time_of_day
ORDER BY hour;


-- 6. Weekly Trend by Ad Type -- 

SELECT 
    e.day_of_week,
    a.ad_type,
    COUNT(*) AS engagements
FROM Meta e
JOIN ads a ON e.ad_id = a.ad_id
WHERE e.event_type IN ('Click','Share','Comment')
GROUP BY e.day_of_week, a.ad_type
ORDER BY e.day_of_week;

-- 7. Ad Type Performance  -- 

SELECT 
    a.ad_type,

    COUNT(CASE WHEN e.event_type = 'Impression' THEN 1 END) AS impressions,
    COUNT(CASE WHEN e.event_type = 'Click' THEN 1 END) AS clicks,
    COUNT(CASE WHEN e.event_type = 'Purchase' THEN 1 END) AS purchases,

    ROUND(
        COUNT(CASE WHEN e.event_type = 'Click' THEN 1 END) * 100.0 /
        NULLIF(COUNT(CASE WHEN e.event_type = 'Impression' THEN 1 END),0), 
    2) AS ctr,

    ROUND(
        COUNT(CASE WHEN e.event_type = 'Purchase' THEN 1 END) * 100.0 /
        NULLIF(COUNT(CASE WHEN e.event_type = 'Click' THEN 1 END),0), 
    2) AS conversion_rate

FROM meta e
JOIN ads a ON e.ad_id = a.ad_id
GROUP BY a.ad_type
ORDER BY ctr DESC;


-- 8. Platform Comparison -- 

SELECT 
    a.ad_platform,

    COUNT(CASE WHEN e.event_type = 'Impression' THEN 1 END) AS impressions,
    COUNT(CASE WHEN e.event_type = 'Click' THEN 1 END) AS clicks,
    COUNT(CASE WHEN e.event_type = 'Purchase' THEN 1 END) AS purchases

FROM Meta e
JOIN ads a ON e.ad_id = a.ad_id
GROUP BY a.ad_platform;

-- 9. Budget Analysis -- 

SELECT 
    SUM(total_budget) AS total_budget,
    AVG(total_budget) AS avg_budget_per_campaign
FROM campaigns;
