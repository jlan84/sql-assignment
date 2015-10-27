SELECT userid
FROM users
LIMIT 10;

SELECT DISTINCT campaign_id
FROM users;

SELECT *
FROM users
WHERE campaign_id = 'FB';

SELECT userid, dt
FROM users
WHERE campaign_id = 'FB';

SELECT count(*)
FROM users
WHERE campaign_id = 'FB';

SELECT campaign_id, count(*)
FROM users
GROUP BY campaign_id;

SELECT count(DISTINCT dt)
FROM users;

SELECT min(dt) as first, max(dt) as last
FROM users;

