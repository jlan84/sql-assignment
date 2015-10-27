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

SELECT avg(price)
FROM meals;

SELECT type, avg(price), min(price), max(price)
FROM meals
GROUP BY type;

SELECT type, avg(price) AS avg_price, min(price) 
	AS min_price, max(price) AS max_price
FROM meals
GROUP BY type;

SELECT type, avg(price) AS avg_price, min(price) 
	AS min_price, max(price) AS max_price
FROM meals
WHERE date_part('month', dt) <= 3 
	AND date_part('year', dt) = 2013
GROUP BY type;

SELECT type, date_part('month', dt) AS month, 
	avg(price) AS avg_price, min(price) AS min_price, 
	max(price) AS max_price
FROM meals
GROUP BY type, month;

SELECT meal_id, sum(CASE WHEN event = 'bought' THEN 1 ELSE 0 END) AS purchases,
	sum(CASE WHEN event = 'like' THEN 1 ELSE 0 END) AS likes,
	sum(CASE WHEN event = 'share' THEN 1 ELSE 0 END) AS shares
FROM events
GROUP BY meal_id;

SELECT type, avg(price) as avg_price
FROM meals
GROUP BY type
ORDER BY type;

SELECT type, avg(price) as avg_price
FROM meals
GROUP BY type
ORDER BY avg_price DESC;

SELECT type, avg(price) as avg_price
FROM meals
GROUP BY type
ORDER BY type, avg_price DESC;

SELECT u.userid, campaign_id, meal_id, event
FROM users u JOIN events e
	ON u.userid = e.userid;

SELECT u.userid, campaign_id, e.meal_id
FROM users u JOIN events e
	ON u.userid = e.userid
JOIN meals m
	ON e.meal_id = m.meal_id
	AND event = 'bought';

SELECT type, count(type)
FROM meals m JOIN events e
	ON m.meal_id = e.meal_id
	AND event = 'bought'
GROUP BY type;

/* SUBQUERIES */

SELECT *
FROM meals
WHERE price > (SELECT avg(price)
FROM meals);

SELECT *
FROM meals m JOIN 
	(SELECT type, avg(price) AS avg_price
	FROM meals
	GROUP BY type) a
ON m.type = a.type
	AND m.price > a.avg_price;


SELECT m.type, count(*)
FROM meals m JOIN 
	(SELECT type, avg(price) AS avg_price
	FROM meals
	GROUP BY type) a
ON m.type = a.type
	AND m.price > a.avg_price
GROUP BY m.type;

SELECT campaign_id, CAST(count(*) AS REAL) / 
	(SELECT count(DISTINCT userid) FROM users) AS percent
FROM users
GROUP BY campaign_id;



CREATE TABLE mytable AS
	SELECT u.userid, campaign_id, count(*) AS meals_bought
	FROM events e JOIN users u
	ON e.userid = u.userid
	AND e.event = 'bought'
	GROUP BY u.userid, campaign_id;

SELECT m1.*
FROM mytable m1
INNER JOIN (SELECT campaign_id, max(meals_bought) 
			AS max_bought
			FROM mytable
			GROUP BY campaign_id) m2
ON m1.campaign_id = m2.campaign_id
AND meals_bought = max_bought;


/*ALTERNATIVELY:*/
WITH user_campaign_counts AS (
    SELECT campaign_id, users.userid, COUNT(1) AS cnt
    FROM users
    JOIN events
    ON users.userid=events.userid
    GROUP BY campaign_id, users.userid)

SELECT u.campaign_id, u.userid, u.cnt
FROM user_campaign_counts u
JOIN (SELECT campaign_id, MAX(cnt) AS cnt
      FROM user_campaign_counts
      GROUP BY campaign_id) m
ON u.campaign_id=m.campaign_id AND u.cnt=m.cnt
ORDER BY u.campaign_id, u.userid;

/* For each day, get the total number of users who have registered as of that day.
You should get a table that has a dt and a cnt column. This is a cumulative sum.*/

SELECT a.dt, COUNT(1)
FROM (SELECT DISTINCT dt FROM users) a
JOIN users b
ON b.dt <= a.dt
GROUP BY a.dt
ORDER BY a.dt;

/* Which day of the week gets meals with the most buys */

SELECT date_part('dow', meals.dt) AS dow, COUNT(1) AS cnt
FROM meals
JOIN events
ON
    meals.meal_id=events.meal_id AND
    event='bought'
GROUP BY 1
ORDER BY cnt DESC
LIMIT 1;

/*Which month had the highest percent of users who visited the site 
purchase a meal? */













