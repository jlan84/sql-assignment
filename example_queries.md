1. Basic use of aggregates to get the maximum and minimum

    ```sql
    SELECT MIN(dt), MAX(dt) FROM visits;
    ```

2. Getting the count of visits on each date. Don't forget to group by the date!

    ```sql
    SELECT dt, COUNT(1) FROM visits GROUP BY dt;
    ```

    If you forget the group by, postgres will tell you:

    ```
    readychef=# SELECT dt, COUNT(1) FROM visits;
    ERROR:  column "visits.dt" must appear in the GROUP BY clause
            or be used in an aggregate function
    LINE 1: SELECT dt, COUNT(1) FROM visits;
                   ^
    ```

3. Recall that `HAVING` is used when you want to use `WHERE` for an aggregate.

    ```sql
    SELECT dt, COUNT(1) AS cnt
    FROM visits
    GROUP BY dt
    HAVING COUNT(1) > 1000;
    ```

    ***Incorrect Versions:***

    * Using where instead of having. This doesn't work because the `WHERE` clause is executed *before* aggregate functions.
        
        ```
        readychef=# SELECT dt, COUNT(1) FROM visits
                    WHERE COUNT(1) > 1000 GROUP BY visits;
        ERROR:  aggregate functions are not allowed in WHERE
        LINE 1: ...FROM visits WHERE COUNT(1) > 1000 GROUP ...
                                     ^
        ```

    * Using an alias for the count in the having clause
    
        ```
        readychef=# SELECT dt, COUNT(1) AS cnt FROM visits
                    GROUP BY dt HAVING cnt > 1000;
        ERROR:  column "cnt" does not exist
        LINE 1: ...GROUP BY dt HAVING cnt > 1000...
                                      ^
        ```
    
4. How to create a table. This can be used for testing your queries on smaller tables. It's also useful if you want to save results, or if you have a complicated query and want to make a temporary intermediary table.

    ```sql
    CREATE TABLE mini_visits AS
        SELECT * FROM VISITS LIMIT 10;
    ```

5. A more complicated query. This counts the number of times each Californian user has visited the site.

    *Note:* This isn't for the readychef data. Just pretend we also have name and state in our users table.

    ```sql
    SELECT
        users.userid,
        name,
        COUNT(1) AS cnt
    FROM users
    JOIN visits
    ON
        users.userid=visits.userid AND
        users.state='CA'
    GROUP BY users.userid, users.name;
    ```

    Note that we need `users.name` in the group by even though there aren't two users with the same userid and different names. We always need every column from the select in the group by. This is not the case in sqlite, but is the case in most sql languages, including postgres.

    You could get the same results by using the `WHERE` clause, but this would be less efficient since it would create the join of the two tables and then filter out the california rows. Here's what this would look like:

    ```sql
    SELECT
        users.userid,
        name,
        COUNT(1) AS cnt
    FROM users
    JOIN visits
    ON users.userid=visits.userid
    WHERE users.state='CA'
    GROUP BY users.userid, users.name;
    ```
