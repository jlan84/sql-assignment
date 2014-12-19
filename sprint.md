SQL Sprint
======================================

Overview
===================
In this exercise, we are going to learn the basics of SQL and gain an understanding of what an [RDBMS](http://en.wikipedia.org/wiki/Relational_database_management_system) has to offer. Databases are based on a very simple idea of CRUD (Create, Read, Update, Delete). As a data scientist, your primary role will be the Read part to do some analysis.

We've created a fake company called *ReadyChef* with simulated data. The database is a simulation of a user database for a food e-commerce website where users have different activities such as sharing, liking, and buying of posted meals.

We are going to focus on general reporting with regards to revenue, referrals, and other basic questions you would face on the job.

Goals
======================
   1. Explore the Database
   2. Basic Querying - Selecting From Tables
   3. Selecting specific attributes of a table
   4. Where clause/ filtering
   5. Aggregation functions: counting
   6. Aggregation functions: AVG
   7. Intervals, Ranges, and sorting
   8. Subqueries
   9. More subqueries - a whole tutorial
   10. Extra Tutorial on selects

Setting up Postgres
================================
Here's the [postgres docs](http://www.postgresql.org/docs/9.3/interactive/) which often prove useful for figuring stuff out.

To set postgres up on your personal computer, follow the following steps (for a mac).

1. Install your Postgres database. The easiest way to to install the pre-build application (with an adorable icon) using the following command:

    ```
    brew cask install postgres
    ```

    If you don't have homebrew, go [here](http://brew.sh/).

2. After the installation is complete, use Spotlight to search for `postgres` and open the Application. It will ask you if you want to move it to the Applications folder, say "Move it"

Loading the database
======================

In this repo, there's a SQL dump of the data we'll be using today.

1. From the commandline run `psql` and then these commands:

    ```sql
    CREATE USER postgres SUPERUSER;
    CREATE DATABASE readychef;
    \q
    ```

1. Navigate to where you cloned this very repository and run the following command to import the database:

    ```
    psql readychef < readychef.sql
    ```

    You should see a bunch of SQL commands flow through the terminal. 

1. To enter the interactive Postgres prompt, now enter the following to be connected or your database.

    ```
    psql readychef
    ```

Now we are in a command line client. This is how we will explore the database to gain an understanding of what data we are playing with.

Basic Exploration
=================

First, we will want to see what the available tables are. Remember, now that we are in the database, all of our commands or actions will be on the `readychef` database.

1. What are the tables in our database? Run `\d` to find out.

2. What columns does each table have? Run `\d tablename` to find out.


Select statements
===================

1. To get an understanding of the data, run a [SELECT](http://www.postgresqltutorial.com/postgresql-select/) statement on each table. Keep all the columns and limit the number of rows to 10.

2. Write a `SELECT` statement that would get just the userids.

3. Maybe you're just interested in what the campaign ids are. Use 'SELECT DISTINCT' to figure out all the possible values of that column.

    *Note:*  Pinterest=PI, Facebook=FB, Twitter=TW, and Reddit=RE

Where Clauses / Filtering
========================================

Now that we have the lay of the land, we're interested in the subset of users that came from Facebook (FB). If you're unfamiliar with SQL syntax, the [WHERE](http://www.postgresqltutorial.com/postgresql-where/) clause can be used to add a conditional to `SELECT` statements. This has the effect of only returning rows where the conditional evaluates to `TRUE`. 

*Note: Make sure you put string literals in single quotes, like `campaign_id='TW'`.*

1. Using the `WHERE` clause, write a new `SELECT` statement that returns all rows where `Campaign_ID` is equal to `FB`.

2. We don't need the campaign id in the result since they are all the same, so only include the other two columns.

    Your output should be something like this:

    ```
     userid |     dt
    --------+------------
          3 | 2013-01-01
          4 | 2013-01-01
          5 | 2013-01-01
          6 | 2013-01-01
          8 | 2013-01-01
    ...
    ```

Aggregation Functions
=======================

Let's try some [aggregation functions](http://www.postgresql.org/docs/8.2/static/functions-aggregate.html) now.

`COUNT` is an example aggregate function, which counts all the entries and you can use like this:

```sql
SELECT COUNT(*) FROM users;
```

Your output should look something like:

```
 count
-------
  5524
(1 row)
```

1. Write a query to get the count of just the users who came from Facebook.

2. Now, count the number of users coming from each service. Here you'll have to group by the column you're selecting with a [GROUP BY](http://www.postgresql.org/docs/8.0/static/sql-select.html#SQL-GROUPBY) clause.

    Try running the query without a group by. Postgres will tell you what to put in your group by clause!

3. Use `COUNT (DISTINCT columnname)` to get the number of unique dates that appear in the `users` table.

4. There's also `MAX` and `MIN` functions, which do what you might expect. Write a query to get the first and last registration date from the `users` table.

5. Calculate the mean price for a meal (from the `meals` table). You can use the `AVG` function. Your result should look like this:

    ```
             avg
    ---------------------
     10.6522829904666332
    (1 row)
    ```

6. Now get the average price, the min price and the max price for each meal type. Don't forget the group by statement!

    Your output should look like this:

    ```
        type    |         avg         | min | max
    ------------+---------------------+-----+-----
     mexican    |  9.6975945017182131 |   6 |  13
     french     | 11.5420000000000000 |   7 |  16
     japanese   |  9.3804878048780488 |   6 |  13
     italian    | 11.2926136363636364 |   7 |  16
     chinese    |  9.5187165775401070 |   6 |  13
     vietnamese |  9.2830188679245283 |   6 |  13
    (6 rows)
    ```

7. We can always rename columns that we select by doing `COUNT(*) AS total_count`. This is called [aliasing](http://stackoverflow.com/questions/15413735/postgresql-help-me-figure-out-how-to-use-table-aliases). Write a query to get the average price for each type and name the average column `avg_price`.

    You output should look like this:

    ```
        type    |    average_price
    ------------+---------------------
     mexican    |  9.6975945017182131
     french     | 11.5420000000000000
    ...
    ```

Intervals, Ranges, and sorting
==========================================

1. Using the previous query, let's answer the question on what meal type
   can be the most profitable. Using the [ORDER BY](http://www.postgresqltutorial.com/postgresql-order-by/) operator, sort the rows in descending order by average. This will allow us to understand how to rank by mean meal price. One important thing to understand is the proper use of [aliasing](http://stackoverflow.com/questions/15413735/postgresql-help-me-figure-out-how-to-use-table-aliases) so that the averages created in the `SELECT` statement are available to the `ORDER BY` clause.

    Your output should look like:

    ```
           Type    |      avg_price
       ------------+---------------------
        chinese    | 10.2047244094488189
        german     | 10.1027496382054993
       ...
    ```

2. Next, let's experiment with ranges and intervals. Again, get the average price per meal type and this time, restrict the query to only average rows with a food type price greater than or equal to 10. (Grab food items with a price >= 10 only, then average).

    ```
           Type    |      avg_price
       ------------+---------------------
        french     | 12.6951566951566952
        chinese    | 12.6651053864168618
       ...
    ```

Joins
=========================

Now we are ready to do operations on multiple tables. If you remember [joins](http://www.tutorialspoint.com/postgresql/postgresql_using_joins.htm), they allow us to perform aggregate operations on multiple tables. These results will easily get complicated so we should take care to understand what joins are, how each one works on different tables, and how to structure the query so we only return what we need.

1. We'd like to answer the question, _"How many meals did each user buy?"_
     
    We will need to perform a `JOIN` on the both the `Event` and `Meal` tables.

    First, we want to restrict our query to focus on users that actually purchased something. We can do this by [filtering](http://www.techonthenet.com/sql/where.php) the rows to return where the Event type is `bought`.
     
    Next, `JOIN` the users and meal tables on their common `id` and `GROUP BY` User id.

    You should get something like this:

    ```
       id  | count
     ------+-------
      1548 |     1
       106 |     4
      1513 |     1
      2125 |     1
       276 |     2
       606 |     2
      1439 |     2
      1728 |     2
      2285 |     2
      1676 |     1
       807 |     1
      1231 |     2
       151 |     1
      1692 |     1
       253 |     2
       852 |     1
       437 |     2
      4875 |     1
       549 |     3
       268 |     1
       310 |     3
      2055 |     1
       etc.
    ```

Joins and aggregations
===========================

Now let's start doing some aggregate analysis.

1. Answer the question, _"What user from each campaign bought the most items?"_

    This will be composed of a multi-table join, ranking by count of a column,  and then grouping by column value types.

    ```
    Campaign_ID | count | count
    -------------+-------+-------
    PI          |   532 |   532
    (1 row)
    ```

*Phew!* If you've made it this far, congratulations! You're ready to move on to subqueries.

Subqueries
================================

Here is an example of a [subquery](http://www.postgresql.org/docs/8.1/static/functions-subquery.html):

```
 SELECT cost1,
        quantity_1,
        cost_2,
        quantity_2
        total_1 + total_2 as total_3
 FROM (
     SELECT cost_1,
            quantity_1,
            cost_2,
            quantity_2,
            (cost_1 * quantity_1) AS total_1,
            (cost_2 * quantity_2) AS total_2
     FROM data
 ) t
```

There is a lot going on here. Take a moment to read and thorougly understand [aliasing](http://stackoverflow.com/questions/15413735/postgresql-help-me-figure-out-how-to-use-table-aliases). Try a few subquiries, experiment.

In short, an alias renames a column using the `AS` clause. This also allows us to create temporary columns aka derived attributes.

We are going to use this to create a report of meals that are greater than the average price for each category.

1. Identify items above the average price for the column.

2. From there, count the number of meals per type that are above the average price.
This will allow us to identify meals that might be slightly more profitable.

3. Now do the same thing for anything less than the mean, and do a count on all items that are below the mean price per meal type.

4. Count the number of items by type that are greater than the avg. Your output should look like below:

    ```
        Type    | count
    ------------+-------
     mexican    |   340
     french     |   351
     japanese   |   360
     italian    |   398
     chinese    |   369
     vietnamese |   382
     german     |   316
    (7 rows)
    ```

3. Now calculate the columnwise percentage of users from each service. You will need to use [GROUP BY](http://stackoverflow.com/questions/6207224/calculcating-percentages-with-group-by-query).

Extra Credit
========================

Often times when running a web business you are not interested in simply optimizing a users visit, but rather in optimizing the entire lifetime of visits by a user.  This is typically referred to as Customer lifetime value (CLV).

> In marketing, customer lifetime value (CLV), lifetime customer value (LCV), or user lifetime value (LTV) is a prediction of the net profit attributed to the entire future relationship with a customer.

So far we have used pretty standard SQL features/queries, but now we get to really experience the power of Postgres.  Postgres has many nice advanced analytical features that other databases do not support.  It is for that reason that many data scientists choose Postgres as their tool of choice for analysis.

* [Postgres: The Bits You Haven't Found](http://postgres-bits.herokuapp.com/#1)
* [7 Handy SQL features for Data Scientists](http://blog.yhathq.com/posts/sql-for-data-scientists.html)

### Moving Window

Now we will be getting in to moving window based time series analysis. Many questions asked in todays' work environment often involve doing monthly status reports. In an e-commerce business we typically want to know the likelihoods of certain events or perhaps an average price over time.

Using [Window functions](http://www.postgresql.org/docs/9.1/static/tutorial-window.html) and [Date/Time functions](http://www.postgresql.org/docs/8.4/static/functions-datetime.html) we will first compute some additional metrics to guide our analysis:

1. The number of users created on a given month.

2. The number of times visited per month.

3. The average time between user signups

3. The average # of meals bought per month.

4. The average revenue per month (meals * price of meal).

### Getting Specific!

So far we have computed some interesting _global_ statistics on monthly meals and revenue.  But like all things in life, not everything is created equal.  We have begun to suspect that certain users are much more valuable than others, and considering that it cost different amount to market on Facebook vs. Twitter, etc. we want to adjust our monthly marketing spend on each service to be proportional to how valuable the users that come from that service are.

Recompute the above statistics according to the referrer:

1. The number of users created on a given month from each referrer.

2. Average # of meals bought per month from each referrer.

3. Average monthly revenue by referrer (i.e. how valuable is a user from Facebook?)

We unfortunately have not been good data scientists and have not recorded when users leave our service.  Because of this we cannot know the average lifetime of a user, we only know when they have signed up.  Let this be a lesson to always remember everything.  We will comeback to our CLV calculation in a later sprint, but we have gotten a head-start on our analysis at least by computing some other interesting and useful metrics.

Extra Tutorial:
========================
http://sqlzoo.net/wiki/SELECT_within_SELECT_Tutorial
