--#1 
CREATE TABLE purchases AS SELECT ev.userid, COUNT(ev.*) AS purchases
            , us.campaign_id 
FROM events AS ev
JOIN users AS us
ON ev.userid = us.userid
WHERE event = 'bought'
GROUP BY ev.userid, us.campaign_id;

SELECT p.userid, p.campaign_id, p.purchases
FROM purchases AS p
JOIN (SELECT campaign_id, MAX(purchases) as max_purchases FROM purchases GROUP BY campaign_id) as mx
ON mx.campaign_id = p.campaign_id AND
   p.purchases = mx.max_purchases
ORDER BY p.campaign_id, p.userid;

-- Another way to run this

WITH user_purchases AS(
    SELECT ev.userid, COUNT(ev.*) AS total_purchases, us.campaign_id
    FROM events as ev
    JOIN users as us
    ON ev.userid = us.userid AND ev.event = 'bought'
    GROUP BY ev.userid, us.campaign_id
)

SELECT up.userid, up.campaign_id, up.total_purchases
FROM user_purchases AS up
JOIN (SELECT campaign_id, MAX(total_purchases) AS mx_purchases 
      FROM user_purchases
      GROUP BY campaign_id) AS mx
ON up.campaign_id = mx.campaign_id AND up.total_purchases = mx.mx_purchases
ORDER BY up.userid, up.campaign_id;

--Yet Another Option

SELECT
    campaign_id, userid, buys
FROM
    (SELECT
        campaign_id, userid, buys, MAX(buys) OVER (PARTITION BY campaign_id) AS max_buys
    FROM
        (SELECT
        events.userid, users.campaign_id, COUNT(0) AS buys
        FROM events        
        JOIN users 
        ON users.userid = events.userid
        AND events.event = 'bought'
        GROUP BY events.userid , users.campaign_id) AS buy_tbl) AS outer_buys
WHERE
    buys = max_buys;

--#2

SELECT a.dt, COUNT(userid) AS cnt
FROM (SELECT DISTINCT dt FROM users) as a
JOIN users as b
ON b.dt <= a.dt
GROUP BY a.dt
ORDER BY a.dt; 

--#3

SELECT date_part('dow', ml.dt) AS day_of_week, COUNT(1) AS cnt
FROM meals AS ml
JOIN events AS ev
ON ml.meal_id = ev.meal_id AND
   event='bought'
GROUP BY day_of_week
ORDER BY cnt DESC
LIMIT 1;

--#4
SELECT v.month, v.year, CAST(e.cnt AS REAL)/v.cnt AS percent
FROM (SELECT 
      DATE_PART('month', dt) AS month,
      DATE_PART('year', dt) AS year,
      COUNT(1) AS cnt
      FROM visits
      GROUP BY month, year
      ) AS v
JOIN (SELECT
      DATE_PART('month', dt) AS month,
      DATE_PART('year', dt) AS year,
      COUNT(1) AS cnt
      FROM events
      WHERE event='bought'
      GROUP BY month, year
      ) AS e
ON v.month=e.month AND v.year=e.year
ORDER BY percent DESC
LIMIT 1;

--#5
SELECT a.meal_id, a.price
FROM meals AS a
JOIN meals AS b
ON b.dt <= a.dt AND b.dt > a.dt - 7
GROUP BY a.meal_id, a.price
HAVING a.price > AVG(b.price);

--#6
SELECT CAST(COUNT(1) AS REAL)/(SELECT COUNT(1) FROM users)
FROM (SELECT userid
      FROM events
      GROUP BY userid
      HAVING SUM(CASE WHEN event='share' THEN 1 ELSE 0 END)>
             SUM(CASE WHEN event='like' THEN 1 ELSE 0 END)
      ) AS t;

--#7

SELECT visits.dt, COUNT(1)
    FROM visits
    LEFT OUTER JOIN events
    ON visits.userid=events.userid AND visits.dt=events.dt
    WHERE events.userid IS NULL
    GROUP BY visits.dt;

--#8

SELECT dt
    FROM meals
    GROUP BY dt
    HAVING
        COUNT(1) >
        (SELECT COUNT(1) FROM meals) / (SELECT COUNT(DISTINCT dt) FROM meals);

--#9

SELECT bought.userid
    FROM
    --Subquery to get the datetime of the first 'bought' event
    (SELECT userid,
     MIN(dt) AS first
     FROM events
     WHERE event='bought'
     GROUP BY userid)
     AS bought
    INNER JOIN
    --Subquery to get the datetime of the first 'like,share' event
    (SELECT userid,
     MIN(dt) AS first
     FROM events
     WHERE event IN ('like', 'share')
     GROUP BY userid)
     AS like_share
    --Join the earliest dates from both categories and keep
    --only ones where bought happens first.
    ON bought.userid = like_share.userid
    WHERE bought.first < like_share.first;