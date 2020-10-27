--#1
SELECT meal_id, price
FROM meals
WHERE price > (SELECT AVG(PRICE) FROM meals);

--#2
SELECT ml.*
FROM meals as ml
JOIN (SELECT type, AVG(price) AS avg_price FROM meals GROUP BY type) AS average
ON average.type = ml.type AND
   ml.price > average.avg_price
ORDER BY ml.type;

--#3
SELECT ml.type, COUNT(*)
FROM meals as ml
JOIN (SELECT type, AVG(price) AS avg_price FROM meals GROUP BY type) AS average
ON average.type = ml.type AND
   ml.price > average.avg_price
GROUP BY ml.type
ORDER BY ml.type;

--#4
SELECT us.campaign_id, CAST(COUNT(*) AS REAL)/(SELECT COUNT(*) FROM users) AS percent
FROM users AS us
GROUP BY us.campaign_id;

