-- Where 
-- #1

SELECT * FROM users
WHERE campaign_id = 'FB'

-- #2
SELECT userid, dt FROM users
WHERE campaign_id = 'FB';

--Aggregation
--#1
SELECT COUNT(*) FROM users
WHERE campaign_id = 'FB';

--#2
SELECT campaign_id, COUNT(*) FROM users
GROUP BY campaign_id;

--#3
SELECT COUNT(DISTINCT dt) FROM users;

--#4
SELECT MIN(dt) AS FirstDate, MAX(dt) AS LastDate
FROM users;

--#5
SELECT AVG(price) AS AveragePrice FROM meals;

--#6
SELECT AVG(price), MAX(price), MIN(price)
FROM meals
GROUP BY type;

--#7
SELECT AVG(price) AS avg_price, MAX(price) AS max_price, MIN(price) AS min_price
FROM meals
GROUP BY type;

--#8
SELECT 
DATE_PART('month', dt) AS month,
DATE_PART('year', dt) AS year
FROM meals
WHERE date_part('month', dt)<=3 AND date_part('year', dt) = 2013;

--#9
SELECT type, 
DATE_PART('month', dt) AS month,
AVG(price) AS avg_price,
MIN(price) AS min_price,
MAX(price) AS max_price
FROM meals
WHERE date_part('month', dt)<=3 AND date_part('year', dt) = 2013
GROUP BY type, month;

--#10
SELECT meal_id, SUM(CASE WHEN event = 'bought' THEN 1 ELSE 0 END) AS bought,
       SUM(CASE WHEN event = 'like' THEN 1 ELSE 0 END) AS liked,
       SUM(CASE WHEN event = 'share' THEN 1 ELSE 0 END) AS shared
FROM events
GROUP BY meal_id;

--Sorting
--#1 
SELECT type, AVG(price) AS avg_price
FROM meals
GROUP BY type;

--#2
SELECT type, AVG(price) AS avg_price
FROM meals
GROUP BY type
ORDER BY type;

--#3
SELECT type, AVG(price) AS avg_price
FROM meals
GROUP BY type
ORDER BY avg_price DESC;

--#4
SELECT type, AVG(price) AS avg_price
FROM meals
GROUP BY type
ORDER BY type, avg_price;

--#5
SELECT type, dt
FROM meals
ORDER BY 1;

--Joins
--#1
SELECT us.userid, us.campaign_id, ev.meal_id, ev.event
FROM users AS us
JOIN events AS ev
ON us.userid = ev.userid
LIMIT 5;

--#2
SELECT us.userid, us.campaign_id, ev.meal_id, ev.event, ml.type, ml.price
FROM users AS us
JOIN events AS ev
ON us.userid = ev.userid
JOIN meals AS ml
ON ev.meal_id = ml.meal_id AND
   ev.event = 'bought'
LIMIT 5;

--#3
SELECT ml.type, COUNT(*)
FROM users AS us
JOIN events AS ev
ON us.userid = ev.userid
JOIN meals AS ml
ON ev.meal_id = ml.meal_id AND
   ev.event = 'bought'
GROUP BY ml.type;

