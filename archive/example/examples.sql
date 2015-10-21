-- List the tables in the database

-- Check details of musician table

-- Check out the first five rows from band
SELECT * FROM band LIMIT 5;

-- How many rows total?
SELECT COUNT(*) FROM band;

-- Get min and max born date from musician table
SELECT
    MIN(born),
    MAX(born)
FROM musician;


-- Getting the types of instruments with counts by type of music for the performers
SELECT
    perf_type,
    instrument,
    COUNT(*)
FROM performer
GROUP BY perf_type, instrument
ORDER BY perf_type, count DESC;

-- Selecting the types of instruments with counts for only 'classical'
SELECT
    perf_type,
    instrument,
    COUNT(*)
FROM performer
WHERE perf_type = 'classical'
GROUP BY perf_type, instrument
ORDER BY perf_type, count DESC;

-- What about if you want to condition on the aggregate variable you created
SELECT
    perf_type,
    instrument,
    COUNT(*)
FROM performer
GROUP BY perf_type, instrument
HAVING COUNT(*) > 2
ORDER BY perf_type, count DESC;

-- How many total musicians are alive/dead?
SELECT
    CASE
        WHEN died IS NULL THEN 1 ELSE 0
        END AS is_alive,
    COUNT(*)
FROM musician
GROUP BY is_alive;

-- What fraction of musicians are alive?
SELECT
    AVG(CASE WHEN died IS NULL THEN 1 ELSE 0 END) as fraction_alive
FROM musician;

#Part 2: Joins

-- Give the names of musicians that organized concerts in the Assembly Rooms after the first of Feb, 1997.
SELECT
    musician.m_name
FROM musician JOIN concert
ON musician.m_no = concert.concert_orgniser
WHERE concert.concert_venue = 'Assembly Rooms';

-- Find all the performers who played guitar or violin, and were born in England
SELECT
m.m_name,
p.instrument,
pl.place_country
FROM musician m
JOIN performer p on m.m_no = p.perf_is
JOIN place pl on pl.place_no = m.born_in
WHERE p.instrument IN ('guitar','violin')
AND pl.place_country = 'England';


-- Part 3: Complex queries with Subqueries

-- List the names, dates of birth and the instrument played of living musicians who play a instrument which Theo Mengel also plays
SELECT
    m.m_name,
    m.born,
    p.instrument
FROM musician m JOIN performer p
ON m.m_no = p.perf_is
WHERE m.died IS NULL
AND p.instrument IN (
    SELECT instrument
    FROM musician m JOIN performer p
    ON m.m_no = p.perf_is
    WHERE m.m_name = 'Theo Mengel'
);

-- List the name and town of birth of any performer born in the same city as James First.

SELECT
    m.m_name,
    p.place_town
FROM musician m, place p
WHERE m.born_in = p.place_no
AND p.place_town = (
    SELECT place.place_town
    FROM musician, place
    WHERE musician.born_in = place.place_no
    AND musician.m_name = 'James First'
);

-- Alternatively
WITH t AS (
    SELECT
        m.m_name,
        p.place_town
    FROM musician AS m INNER JOIN place AS p
    ON m.born_in = p.place_no
)
SELECT
    m_name,
    place_town
FROM t
WHERE place_town = (
    SELECT place_town
    FROM t
    WHERE m_name = 'James First'
);

-- Alternatively
DROP TABLE IF EXISTS mytab;
CREATE TEMP TABLE mytab AS
SELECT
    m.m_name,
    p.place_town
FROM musician AS m INNER JOIN place AS p
ON m.born_in = p.place_no;

SELECT
    m_name,
    place_town
FROM mytab
WHERE place_town = (
    SELECT place_town
    FROM mytab
    WHERE m_name = 'James First'
);

-- Download mytab to my machine
\copy (SELECT * FROM mytab) to 'mytab.csv' WITH DELIMITER ',' CSV HEADER


-- List the name and the number of players for the band whose number of players is greater than the average number of players in each band.

WITH t AS(
    SELECT
        band_id,
        count(*) as band_size
    FROM plays_in
    GROUP BY band_id
)
SELECT
    b.band_name,
    t.band_size
FROM band b, t
WHERE b.band_no = t.band_id
AND t.band_size > (SELECT AVG(band_size) FROM t);
